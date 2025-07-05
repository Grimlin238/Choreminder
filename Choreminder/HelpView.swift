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
    
    init(index: Int = 0) {
        
        _index = State(initialValue: index)
        
    }
    
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
    
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            Spacer()
            helpTextView
                Spacer()
            
        }
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .background(Color.indigo)
        .foregroundColor(.white)
         
        .toolbar(.hidden, for: .tabBar)
        // .navigationTitle("Tutorial")
        
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

