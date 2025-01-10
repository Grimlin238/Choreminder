/*
 MainView.swift
 Copyright 2024 Tyian R. Lashley
 All rights reserved.
 */

import SwiftUI

struct MainView: View {
    @AppStorage("hasSeenWelcomeView") private var toggleView = false
    @State private var index = 0
    @EnvironmentObject var choreStore: ChoreStore
    @AccessibilityFocusState private var focus: Bool

    private var welcomeScreen: some View {
        VStack {
            Spacer()
            
            Text(choreStore.welcomeScreens[index].title)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .accessibilityAddTraits(.isHeader)
                .accessibilityFocused($focus)
            
            Text(choreStore.welcomeScreens[index].body)
                .font(.subheadline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
    }
    
    private var navigationButton: some View {
        Button(action: handleButtonAction) {
            Text(index == choreStore.welcomeScreens.count - 1 ? "Get Started" : "Next")
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
        }
        .padding()
    }
    
    var body: some View {
        ZStack {
        
            Color.indigo
                .ignoresSafeArea()
            
            if toggleView {
                ContentView()
                    .transition(.move(edge: .trailing))
            } else {
                VStack {
                    welcomeScreen
                    Spacer()
                    navigationButton
                        .padding(.horizontal)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    private func handleButtonAction() {
        focus = true
        withAnimation {
            if index == choreStore.welcomeScreens.count - 1 {
                toggleView = true
            } else {
                index += 1
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ChoreStore())
    }
}
