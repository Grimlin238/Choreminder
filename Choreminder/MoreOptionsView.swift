/*
 MoreOptionsView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 

import SwiftUI

struct MoreOptionsView: View {
        
    let optionList = ["Settings", "Help", "Get Support"]
    
    var body: some View {
        NavigationStack {
            VStack {
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
                        
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        
                    }
                }
                .scrollContentBackground(.hidden)
                
                Spacer()
                    Text("Version 1.0")
                    
                }
            .background(Color.indigo)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        
    }
    
    private func destinationView(destination: String) -> some View {
        
        switch(destination) {
            
        case "Settings":
            return AnyView(SettingsView())
            
        case "Help":
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
