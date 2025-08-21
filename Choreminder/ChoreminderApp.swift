/*
 ChoreminderApp.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 
import SwiftUI

@main
struct ChoreminderApp: App {

    @StateObject var choreStore = ChoreStore()
    @AppStorage("hasSeenWelcomeView") var toggleView: Bool = false
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(choreStore)
                .onAppear {
                    NotificationManager.requestPermission()
                    BackgroundTaskManager.registerBackgroundTask()
                    BackgroundTaskManager.scheduleAppRefreshTask()
                }
        }
    }
}
