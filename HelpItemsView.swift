/*
 HelpItemsView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */

import SwiftUI

struct HelpItemsView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    
    @AccessibilityFocusState private var focus: Bool
    
    private var HelpHeader: some View {
        
        VStack {
            
            Text("Get Help with Chore")
                .font(.title)
                .accessibility(addTraits: .isHeader)
                .accessibilityFocused($focus)
                .padding()
            
            Text("Before you go sending an email, see if one of the help items below can help you.")
                .font(.headline)
                .padding()
        
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private var helpList: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                List {
                    
                    ForEach(choreStore.helpItems.enumerated().map { ($0, $1) }, id: \.0) { index, item in
                        
                        NavigationLink(destination: HelpView(index: index)) {
                            
                            Text("\(item.header)")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .accessibilityHint("Double tap to activate help item")
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        .padding()
                        
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    var body: some View {
        
        VStack {
            HelpHeader
                .padding(.horizontal, 16)
            
            helpList
                .padding(.horizontal, 16)
            
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Help")
        .onAppear {
            
            focus = true
            
        }
    }
}
    
struct HelpItemsView_previews: PreviewProvider {
    
    static var previews: some View {
        
        HelpItemsView()
        .environmentObject(ChoreStore())
        
    }
}
