/*
 MoreOptionsView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 

import SwiftUI

struct MoreOptionsView: View {
        
    let optionList = ["Settings", "Tutorial", "Get Support"]
    
    @AccessibilityFocusState private var focus: Bool
    
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
                        
                        NavigationLink(destination: destinationView(destination: option)) {
                            
                            Text(option)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .accessibilityHint("Double tap to activate")
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        .padding()
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
            
        case "Tutorial":
            return AnyView(HelpView())
            
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
