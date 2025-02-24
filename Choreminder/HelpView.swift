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
    
    @AccessibilityFocusState private var focus: Bool
    
    
    private var helpTextView: some View {
        
        VStack {
            
            Text(choreStore.helpItems[index].header)
                .font(.title2)
                .padding()
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($focus)
            
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
                focus = true
            }
            .disabled(index == 0)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            .accessibilityHint("Double tap to go to previous tutorial item.")
            
            Button("Next") {
                
                index = index + 1
                focus = true
                
            }
            .disabled(index == choreStore.helpItems.count - 1)
            .fontWeight(.bold)
            .frame(maxWidth:  .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            .accessibilityHint("Double tap to go to next tutorial item.")
            
        }
        .padding(.horizontal)
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Spacer()
            helpTextView
                
            Spacer()
            helpNavButtonsView
                .padding(.bottom, 16)
            
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Color.indigo)
        .foregroundColor(.white)
         
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Tutorial")
        
        .onAppear {
            
            focus = true
            
        }
        
    }
}

struct HelpView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        HelpView()
            .environmentObject(ChoreStore())
    }
}

