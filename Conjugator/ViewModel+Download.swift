//
//  ViewModel+Download.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import SwiftUI

extension ViewModel {
    func getCourse(from dataSource: String) async -> Course? {
        let dataSourceURL = getDataSourceURL(from: dataSource)
        guard let csv = await downloadCourseCSV(dataSourceURL: dataSourceURL) else { return nil }
        let parsingGroups = generateParsingGroupsFromCSV(csv: csv)
        let course = await createCourse(dataSource: dataSource, parsingGroups: parsingGroups)
        return course
    }

    func getDataSourceURL(from dataSourceID: String) -> String {
        return "https://docs.google.com/spreadsheets/d/\(dataSourceID)/gviz/tq?tqx=out:csv"
    }

    func downloadCourseCSV(dataSourceURL: String) async -> String? {
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

    func createCourse(dataSource: String, parsingGroups: [ParsingGroup]) async -> Course? {
        var course: Course?

        for parsingGroup in parsingGroups {
            switch parsingGroup.kind {
            case .course:
                course = Course.create(dataSource: dataSource, parsingGroup: parsingGroup)
            case .level:
                let level = Level.create(from: parsingGroup)
                course?.levels.append(level)
            }
        }

        return course
    }
}
