//
//  ViewModel.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 10/12/22.
//  Copyright © 2022 A. Zheng. All rights reserved.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var levels = [Level]()
    @Published var selectedLevel: Level?
    let dataSourceURL = "https://docs.google.com/spreadsheets/d/1YPjLpsEVsRzHk5dD8iAybz4ALG9uaSvOk3eqqIg1mn4/gviz/tq?tqx=out:csv"

    @Published var csv = ""

    init() {
        self.levels = Level.testingLevels
    }

    func loadLevels() async {
        guard let csv = await downloadLevelsCSV() else { return }

        await { @MainActor in
            self.csv = csv
        }()
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
}
