/*
 NotificationManager.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(title: String, body: String, eventDate: Date, weekday: Weekday, day: Int, recurring: Repeating) -> [String] {
        
        var notificationIds = [String]()
        
        switch(recurring) {
            
        case .none:
            let id = scheduleNotificationAtDate(title: title, body: body, date: eventDate)
            notificationIds.append(id)
            
        case .daily:
            let id = scheduleDailyNotification(title: title, body: body, eventDate: eventDate, accurring: .day)
            notificationIds.append(id)
            
        case .weekly:
            let id = scheduleWeeklyNotification(title: title, body: body, eventDate: eventDate, weekday: weekday)
            notificationIds.append(id)
            
        case .monthly:
            let id = scheduleMonthlyNotification(title: title, body: body, eventDate: eventDate, date: day)
            notificationIds.append(id)
            
        }
        
        return notificationIds
        
    }
    
    private func scheduleMonthlyNotification(title: String, body: String, eventDate: Date, date: Int) -> String {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = .default
        
        let identifier = UUID().uuidString
        
        let originalDate = eventDate
        
        let calendar = Calendar.current
        
        let timeComponents = calendar.dateComponents([.hour, .minute], from: originalDate)
        
        var dateComponents = DateComponents()
        
        dateComponents.day = date
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                
                print("There was an error scheduling monthly notification.")
                
                
            } else {
                
                print("Successfully scheduled notification.")
                
            }
        }
        
        return identifier
        
    }
    
    private func scheduleWeeklyNotification(title: String, body: String, eventDate: Date, weekday: Weekday) -> String {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = .default
        
        let identifier = UUID().uuidString
       
        let originalDate = eventDate
        
        let calendar = Calendar.current
        
        let timeComponents = calendar.dateComponents([.hour, .minute], from: originalDate)
        
        var dateComponents = DateComponents()
        
        dateComponents.weekday = weekday.rawValue
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
            if let error = error {
                
                print("Error scheduleing notification. \(error)")
                
            } else {
                
                print("Successfully scheduled weekly notification")
                
            }
        }
        
        return identifier
        
    }
    
    private func scheduleDailyNotification(title: String, body: String, eventDate: Date, accurring: NSCalendar.Unit) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let timeInterval = eventDate.timeIntervalSinceNow
                
        var triggerDateComponents = Calendar.current.dateComponents([.hour, .minute], from: eventDate)
               
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)
        let identifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling repeating notification: \(error.localizedDescription)")
            } else {
                print("Repeating notification scheduled with interval \(accurring)")
            }
        }
        
        return identifier
    }
    
    private func scheduleNotificationAtDate(title: String, body: String, date: Date) -> String {
        let timeInterval = date.timeIntervalSinceNow
        guard timeInterval > 0 else {
            print("Notification not scheduled because the time interval is not greater than 0.")
            return ""
        
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let identifier = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for: \(date)")
            }
        }
        
        return identifier
        
    }
    
    func cancelNotification(identifier: [String]) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifier)
        
    }
    
    
    func scheduleBackgroundNotification(title: String, body: String) {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error)")
                } else {
                    print("Notification scheduled successfully.")
                }
            }
        }

    func updateBadgeCount(count: Int) {
        
        UNUserNotificationCenter.current().setBadgeCount(count) { error in
            
            if let error = error {
                
                print("There was an error setting the badge count. \(error)")
                
            } else {
                
                print("Badge count updated successfully")
                
            }
        }
    }
    
}
