/*
 BackgroundTaskManager.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley
 All rights reserved.
 */

import BackgroundTasks

class BackgroundTaskManager {
    
    private static let choreStore = ChoreStore()
    
    static func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.teelashley.chore.apprefresh", using: nil) { task in
            if let task = task as? BGAppRefreshTask {
                handleAppRefresh(task: task)
            }
        }
    }
    
    static func scheduleAppRefreshTask(time: Int) {
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
    
    private static func handleAppRefresh(task: BGAppRefreshTask) {
        
        let operation = Task {
            print("Starting background task")
    
            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
            
            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
            
            let numBadges = choreStore.numChoresDueToday()
            NotificationManager.updateBadgeCount(count: numBadges)
            
            if numBadges == 0 && !sendMonthly {
                
                print("No operations needed. Exiting task")
                scheduleAppRefreshTask(time: reminderHour)
                                
            } else {
                
                choreStore.removePastChores()
                
                if choreStore.choreList.count == 1 || choreStore.choreList.count > 1 {
                    
                    var notificationBody: String = ""
                    if numBadges == 1 {
                        notificationBody = "You have 1 chore due today. Tap here to view it."
                    } else if numBadges > 1 {
                        notificationBody = "You have \(numBadges) chores due today. Tap here to view them."
                    }
                    
                    NotificationManager.scheduleBackgroundNotification(
                        title: "Chore Reminder",
                        body: notificationBody
                    )
                }
                
                if sendMonthly == true {
                    
                    if DateManager.isBeginningOfMonth() && choreStore.isOccupiedMonth() {
                        
                        NotificationManager.scheduleBackgroundNotification(title: "It's the beginning of the month", body: "You have chores due this month. Tap to view them.")
                        
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
    
    static func handleBackgroundTransition() {
        print("App transitioned to background. Performing cleanup tasks.")
        choreStore.removePastChores()
        let numBadges = choreStore.numChoresDueToday()
        NotificationManager.updateBadgeCount(count: numBadges)
    }
    
    private static func cancelBackgroundTask() {
        
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.teelashley.chore.apprefresh")
        
    }

}
