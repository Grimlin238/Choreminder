/*
 ContentView.swift
 Copyright 2024 Tyin R. Lashley
 All rights reserved.
 */
 
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var notificationManager: NotificationManager
    
    var body: some View {
     
        TabView {
            MyChoreView()
                .tabItem {
                    
                    Text("My Chores")
                    
                }
            
            AddChoreView()
                .tabItem {
                    
                    Text("Create a Chore")
                    
                }
            
            MoreOptionsView()
                .tabItem {
                    
                    Text("More")
                    
                }
        }
        .toolbarBackground(Color.indigo.opacity(0.8))
    }
    }

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView()
            .environmentObject(NotificationManager())
        
    }
}
