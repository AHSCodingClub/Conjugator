//
//  AddCourseView.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import CodeScanner
import SwiftUI

struct AddCourseView: View {
    @ObservedObject var model: ViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text("Scan a course QR code.")

                CodeScannerView(codeTypes: [.qr]) { response in
                    model.showingAddCourseView = false
//                    if case let .success(result) = response {
//                        scannedCode = result.string
//                        isPresentingScanner = false
//                    }
                }
                .ignoresSafeArea()
            }
            .navigationTitle("Add Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarCloseButton()
        }
    }
}
