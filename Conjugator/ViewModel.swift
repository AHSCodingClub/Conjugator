//
//  ViewModel.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var course = Course()
    @Published var levels = [Level]()
    @Published var selectedLevel: Level?
    let dataSourceURL = "https://docs.google.com/spreadsheets/d/1YPjLpsEVsRzHk5dD8iAybz4ALG9uaSvOk3eqqIg1mn4/gviz/tq?tqx=out:csv"

    @Published var csv = ""

    init() {
        self.levels = Level.testingLevels
    }

    func loadLevels() async {
        guard let csv = await downloadLevelsCSV() else { return }

        let parsingGroups = generateParsingGroupsFromCSV(csv: csv)
        print("parsingGroups: \(parsingGroups)")

        await parse(parsingGroups: parsingGroups)

//        await { @MainActor in
//            self.csv = csv
//        }()
    }

    func downloadLevelsCSV() async -> String? {
        guard let url = URL(string: dataSourceURL) else { return nil }

        do {
            let (downloadedFileURL, _) = try await URLSession.shared.download(from: url)
            let data = try Data(contentsOf: downloadedFileURL)
            let string = String(data: data, encoding: .utf8)
            return string
        } catch {
            print("Error downloading levels: \(error)")
        }

        return nil
    }

    func generateParsingGroupsFromCSV(csv: String) -> [ParsingGroup] {
        let lines = csv.components(separatedBy: .newlines)

        var parsingGroups = [ParsingGroup]()
        for line in lines {
            let values = line
                .components(separatedBy: "\",\"") /// separate by ","
                .map {
                    $0.filter { $0 != "\"" } /// remove leading and trailing "
                }

            if let value = values.first {
                switch value.lowercased() {
                case ParsingGroup.Kind.course.rawValue:
                    let parsingGroup = ParsingGroup(kind: .course)
                    parsingGroups.append(parsingGroup)
                case ParsingGroup.Kind.level.rawValue:
                    let parsingGroup = ParsingGroup(kind: .level)
                    parsingGroups.append(parsingGroup)
                default:
                    let line = Line(values: values)
                    if let index = parsingGroups.indices.last {
                        parsingGroups[index].lines.append(line)
                    }
                }
            } else {
                print("Line is blank.")
            }
        }

        return parsingGroups
    }
}
