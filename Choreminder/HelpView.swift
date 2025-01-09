/*
 HelpView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 
import SwiftUI

struct HelpView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    
    @State private var index = 0
    
    private var helpTextView: some View {
        
        VStack {
            
            Text(choreStore.helpItems[index].header)
                .font(.title2)
                .padding()
                .accessibilityAddTraits(.isHeader)
            
            Text(choreStore.helpItems[index].body)
                .font(.body)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var helpNavButtonsView: some View {
        
        HStack(spacing: 16) {
            
            Button("Previous") {
                
                index = index - 1
                
            }
            .disabled(index == 0)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            
            Button("Next") {
                
                index = index + 1
                
            }
            .disabled(index == choreStore.helpItems.count - 1)
            .frame(maxWidth:  .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Spacer()
            helpTextView
                
            Spacer()
            helpNavButtonsView
            
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Color.indigo)
        .foregroundColor(.white)
         
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Tutorial")
        
    }
}

struct HelpView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        HelpView()
            .environmentObject(ChoreStore())
    }
}

