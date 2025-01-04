//
//  ChoreminderApp.swift
//  Choreminder
//
//  Created by Tee Lashley on 1/2/25.
//

import SwiftUI
import BackgroundTasks
import UserNotifications

@main
struct ChoreminderApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var choreStore = ChoreStore()
    @StateObject var notificationManager = NotificationManager()
    @AppStorage("userReminderHour") var reminderHour: Int = 9
    @AppStorage("userSendMonthly") var sendMonthly: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(choreStore)
                .environmentObject(notificationManager)
                .onAppear {
                    notificationManager.requestPermission()
                    registerBackgroundTask()
                    scheduleAppRefreshTask(time: reminderHour)
                }
        }
    
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                
                handleBackgroundTransition()
                scheduleAppRefreshTask(time: reminderHour)
            }
        }
}
    
        func registerBackgroundTask() {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.teelashley.chore.apprefresh", using: nil) { task in
                if let task = task as? BGAppRefreshTask {
                    handleAppRefresh(task: task)
                }
            }
        }

    func scheduleAppRefreshTask(time: Int) {
        cancelBackgroundTask()
        let request = BGAppRefreshTaskRequest(identifier: "com.teelashley.chore.apprefresh")
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        components.hour = time
        components.minute = 0
        components.second = 0

        var nextRunDate = calendar.date(from: components)!
 
        if nextRunDate <= Date() {
            nextRunDate = calendar.date(byAdding: .day, value: 1, to: nextRunDate)!
        }

        request.earliestBeginDate = nextRunDate
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled app refresh task for \(nextRunDate).")
        } catch {
            print("Failed to schedule app refresh task: \(error)")
        }
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        
        let operation = Task {
            print("Starting background task")
            
            let numBadges = choreStore.numChoresDueToday()
            notificationManager.updateBadgeCount(count: numBadges)
            
            if numBadges == 0 && !sendMonthly {
                
                print("No operations needed. Exiting task")
                scheduleAppRefreshTask(time: reminderHour)
                task.setTaskCompleted(success: true)
                
            } else {
                
                choreStore.removePastChores()
                
                if choreStore.choreList.count == 1 || choreStore.choreList.count > 1 {
                    
                    var notificationBody: String = ""
                    if numBadges == 1 {
                        notificationBody = "You have 1 chore due today. Tap here to view it."
                    } else if numBadges > 1 {
                        notificationBody = "You have \(numBadges) chores due today. Tap here to view them."
                    }
                    
                    notificationManager.scheduleBackgroundNotification(
                        title: "Chore Reminder",
                        body: notificationBody
                    )
                }
                
                if sendMonthly == true {
                    
                    if choreStore.isBeginningOfMonth() && choreStore.isOccupiedMonth() {
                        
                        notificationManager.scheduleBackgroundNotification(title: "It's the beginning of the month", body: "You have chores due this month. Tap to view them.")
                        
                    }
                }
                scheduleAppRefreshTask(time: reminderHour)
                
                print("Background task finished")
            }
        }
        
        task.expirationHandler = {
            operation.cancel()
            print("Operation has been canceled")
        }

        Task {
            await operation.value
            task.setTaskCompleted(success: !operation.isCancelled)
            print("Operation completed")
        }
    }
   
    func handleBackgroundTransition() {
        print("App transitioned to background. Performing cleanup tasks.")
        choreStore.removePastChores()
        let numBadges = choreStore.numChoresDueToday()
        notificationManager.updateBadgeCount(count: numBadges)
    }
    
    func cancelBackgroundTask() {
        
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.teelashley.chore.apprefresh")
        
    }
}
