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
    
    static func scheduleAppRefreshTask() {
        cancelBackgroundTask()
        let request = BGAppRefreshTaskRequest(identifier: "com.teelashley.chore.apprefresh")
    
        request.earliestBeginDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Scheduled app refresh task.")
        } catch {
            print("Failed to schedule app refresh task: \(error)")
        }
    }
    
    private static func handleAppRefresh(task: BGAppRefreshTask) {
        
        let operation = Task {
            
            let numBadges = choreStore.numChoresDueToday()
            
            NotificationManager.updateBadgeCount(count: numBadges)
            
            choreStore.removePastChores()
            
            
            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
            
            
            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
            
            NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendMonthly)
            
            scheduleAppRefreshTask()
            
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
    
    private static func cancelBackgroundTask() {
        
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.teelashley.chore.apprefresh")
        
    }

}
