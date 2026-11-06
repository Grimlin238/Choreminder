
/*
 MoreOptionsView.swift
 Part of Chore
 Copyright 2024 Majestee M Daniels
 All rights reserved.
 */

import SwiftUI

struct MoreOptionsView: View {

    let optionList = [
        "Settings",
        "Help",
        "Get Support",
        "Privacy Policy"
    ]

    @AccessibilityFocusState private var focus: Bool

    private let privacyPolicyURL = URL(
        string: "https://grimlin238.github.io/chore-privacy-policy/"
    )!

    private var moreOptionsViewList: some View {
        VStack(spacing: 16) {
            Text("More")
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($focus)

            Spacer()

            List {

                ForEach(optionList, id: \.self) { option in

                    if option == "Privacy Policy" {

                        Link(
                            destination: privacyPolicyURL
                        ) {
                            Text(option)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .accessibilityHint(
                                    "Opens the privacy policy in your browser"
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        .padding()

                    } else {

                        NavigationLink(
                            destination: destinationView(
                                destination: option
                            )
                        ) {

                            Text(option)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .accessibilityHint(
                                    "Double tap to activate"
                                )

                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        .padding()
                    }
                }
            }
            .scrollContentBackground(.hidden)

        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                moreOptionsViewList
                    .padding(.horizontal, 16)

            }
            .background(Color.indigo)
            .foregroundColor(.white)

            .onAppear {
                focus = true
            }
        }
    }

    private func destinationView(destination: String) -> some View {

        switch(destination) {

        case "Settings":
            return AnyView(SettingsView())

        case "Help":
            return AnyView(HelpItemsView())

        case "Get Support":
            return AnyView(GetSupportView())

        default:
            return AnyView(EmptyView())
        }
    }
}

struct MoreOptionsView_previews: PreviewProvider {

    static var previews: some View {

        MoreOptionsView()

    }
}

