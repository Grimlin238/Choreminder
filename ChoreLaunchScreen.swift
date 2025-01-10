/*
 ChoreLaunchScreen.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley
 All rights reserved.
 
 */

import SwiftUI

struct ChoreLaunchScreen: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Do Your Chores")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.all)
    }
}
