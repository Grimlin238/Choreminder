/*
 ChoreminderApp.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 
import SwiftUI

@main
struct ChoreminderApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var choreStore = ChoreStore()
    @AppStorage("userReminderHour") var reminderHour: Int = 9
    @AppStorage("userSendMonthly") var sendMonthly: Bool = false
    @AppStorage("hasSeenWelcomeView") var toggleView: Bool = false
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(choreStore)
                .onAppear {
                    NotificationManager.requestPermission()
                    BackgroundTaskManager.registerBackgroundTask()
                    BackgroundTaskManager.scheduleAppRefreshTask(time: reminderHour)
                }
        }
    }
}
