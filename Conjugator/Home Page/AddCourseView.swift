//
//  AddCourseView.swift
//  Conjugator
//
//  Created by Zheng on 2/13/23.
//

import CodeScanner
import SwiftUI

struct AddCourseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model: ViewModel
    
    @State var text = ""
    @State var error: String?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Enter Course URL")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 0) {
                    TextField("https://docs.google.com/spreadsheets/d/1t-onBgRP5BSHZ26XjvmVgi6RxZmpKO7RBI3JARYE3Bs", text: $text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(UIColor.secondarySystemBackground.color)
                        .onSubmit {
                            Task {
                                await model.addCourse(inputString: text, error: $error) {
                                    withAnimation {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                    
                    Button {
                        Task {
                            await model.addCourse(inputString: text, error: $error) {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text("Next")
                            
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding(.leading, 16)
                        .padding(.trailing, 18)
                        .frame(maxHeight: .infinity)
                        .background(Color.blue)
                    }
                    .opacity(text.isEmpty ? 0.5 : 1)
                    .disabled(text.isEmpty)
                }
                .cornerRadius(16)
                .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .frame(height: 32)
                
                Text("Or Scan QR Code")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                /// `oncePerCode` prevents scanning duplicate codes.
                CodeScannerView(codeTypes: [.qr], scanMode: .oncePerCode) { response in
                    
                    switch response {
                    case .success(let success):
                        Task {
                            await model.addCourse(inputString: success.string, error: $error) {
                                withAnimation {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    case .failure(let failure):
                        error = failure.localizedDescription
                    }
                }
                .cornerRadius(16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .navigationTitle("Add Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarCloseButton()
        }
        .alert(
            "Error Adding Course",
            isPresented: Binding {
                error != nil
            } set: { _ in
                error = nil
            }
        ) {
            Button("OK") {}
        } message: {
            if let error {
                Text("Error: \(error). Please contact your teacher.")
            } else {
                Text("Unknown Error. Please contact your teacher.")
            }
        }
    }
}
