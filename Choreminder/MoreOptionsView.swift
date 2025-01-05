//
//  MoreOptionsView.swift
//  Choreminder
//
//  Created by Tee Lashley on 1/2/25.
//


import SwiftUI

struct MoreOptionsView: View {
        
    let optionList = ["Settings", "Help", "Get Support"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("More")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                    Spacer()
                
                
                List {
                    
                    ForEach(optionList, id: \.self) { option in
                        
                        NavigationLink(destination: destinationView(destination: option)) {
                            
                            Text(option)
                            
                        }
                        
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
                
                Spacer()
                    Text("Version 1.0")
                    
                }
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
