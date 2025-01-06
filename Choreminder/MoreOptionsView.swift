/*
 MoreOptionsView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 

import SwiftUI

struct MoreOptionsView: View {
        
    let optionList = ["Settings", "Tutorial", "Get Support"]
    
    private var moreOptionsViewList: some View {
            VStack(spacing: 20) {
                Text("More")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                
                
                List {
                    
                    ForEach(optionList, id: \.self) { option in
                        
                        NavigationLink(destination: destinationView(destination: option)) {
                            
                            Text(option)
                                .foregroundColor(.white)
                            
                        }
                        .padding()
                        
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
            // .background(Color.purple)
            // .foregroundColor(.white)
        }
    
    var body: some View {
        NavigationStack {
            VStack() {
                Text("More")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                
                moreOptionsViewList
                Spacer()
                
            }
            .background(Color.indigo)
            .foregroundColor(.white)
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
