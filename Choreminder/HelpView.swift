//
//  HelpView.swift
//  Choreminder
//
//  Created by Tee Lashley on 1/2/25.
//
 
import SwiftUI

struct HelpView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    
    @State private var index = 0
    private var helpTextView: some View {
        
        VStack {
            
            Text(choreStore.helpItems[index].header)
            
            Text(choreStore.helpItems[index].body)
        }
    }
    
    private var helpNavButtonsView: some View {
        
        HStack {
            
            Button("Previous") {
                
                index = index - 1
                
            }
            
            Button("Next") {
                
                index = index + 1
                
            }
        }
    }
    
    var body: some View {
        
        VStack {
            
            helpTextView
            Spacer()
            helpNavButtonsView
            
        }
        .background(Color.purple)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Help")
        
    }
}

struct HelpView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        HelpView()
            .environmentObject(ChoreStore())
    }
}

