//
//  AboutView.swift
//  Conjugator
//
//  Created by A. Zheng (github.com/aheze) on 4/16/23.
//  Copyright © 2023 A. Zheng. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var officers: [(position: String, name: String)] = [
        ("President", "Andrew Zheng"),
        ("VP", "Krishna Ram"),
        ("Secretary", "H. Kamran"),
        ("Treasurer", "Isaac Wang"),
        ("Advisor", "Daniel Appel"),
    ]

    var members: [String] = [
        "Leo W.",
        "Amir S.",
        "Clement C.",
        "Eleni C.",
        "James C.",
        "Orion E.",
        "Ariel S.",
        "Caden S.",
        "Michael B.",
        "Ryan M.",
        "Tyler G.",
        "Riley B.",
        "Riley K.",
        "Michael W.",
        "Luigi M.",
        "Ariston S.",
        "Ben R.",
        "Ben T.",
        "Tyler T.",
        "Saylen C.",
        "Liam S.",
        "Marco G.",
        "Blake C.",
        "Nick M.",
        "Ryan F.",
        "Aidan L.",
    ]

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
        }
    }

    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                AboutSectionView(
                    title: "About This App",
                    description: "An app to practice conjugating Spanish verbs!"
                )

                VStack(alignment: .leading, spacing: 20) {
                    AboutSectionView(
                        title: "Made By",
                        description: "AHS Coding Club, Spring 2023 Project"
                    )

                    HStack(alignment: .top, spacing: 48) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Club Officers")
                                .font(.title3.bold())

                            VStack(alignment: .leading) {
                                ForEach(officers, id: \.0) { officer in
                                    Text(officer.position)
                                        .foregroundColor(.primary.opacity(0.75))
                                        + Text(": ").foregroundColor(.primary.opacity(0.75))
                                        + Text(officer.name)
                                }
                            }
                        }
                        .font(.title3)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Club Members")
                                .font(.title3.bold())

                            LazyVGrid(columns: columns) {
                                ForEach(members, id: \.self) { member in
                                    Text(member)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                        .font(.title3)
                    }
                }

                AboutSectionView(
                    title: "Source Code",
                    description:
                    "This is our second app! We made it to learn the Swift programming language. It's open source, so feel free to add whatever you want: [github.com/AHSCodingClub/Conjugator](https://github.com/AHSCodingClub/Conjugator)."
                )

                Text("[Privacy Policy](https://github.com/AHSCodingClub/Conjugator/blob/main/PrivacyPolicy.txt)")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Thank you for everything Natalie 💚")
                    .font(.caption)
            }
            .padding(.horizontal, 20)
            .tint(UIColor.systemGreen.adjust(by: -0.3).color)
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarCloseButton()
    }
}

struct AboutSectionView: View {
    var title: String
    var description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.title.weight(.semibold))

            Text(.init(description)) // extra `init` for Markdown/links
                .font(.title3.weight(.medium))
                .opacity(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
