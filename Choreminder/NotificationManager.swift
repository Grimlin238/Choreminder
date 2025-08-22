/*
 NotificationManager.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    static func scheduleNotification(title: String, body: String, eventDate: Date, weekday: Weekday, day: Int, recurring: Repeating) -> [String] {
        
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
    
    private static func scheduleMonthlyNotification(title: String, body: String, eventDate: Date, date: Int) -> String {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("ChoreAlert.wav"))
        
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
                
                print("There was an error scheduling monthly notification. \(error.localizedDescription)")
            } else {
                
                print("Successfully scheduled notification.")
                
            }
        }
        
        return identifier
        
    }
    
    private static func scheduleWeeklyNotification(title: String, body: String, eventDate: Date, weekday: Weekday) -> String {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("ChoreAlert.wav"))
        
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
    
    private static func scheduleDailyNotification(title: String, body: String, eventDate: Date, accurring: NSCalendar.Unit) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("ChoreAlert.wav"))
        
        let triggerDateComponents = Calendar.current.dateComponents([.hour, .minute], from: eventDate)
               
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
    
    private static func scheduleNotificationAtDate(title: String, body: String, date: Date) -> String {
        let timeInterval = date.timeIntervalSinceNow
        guard timeInterval > 0 else {
            print("Notification not scheduled because the time interval is not greater than 0.")
            return ""
        
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: UNNotificationSoundName("ChoreAlert.wav"))
        
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
    
    static func cancelNotification(identifier: [String]) {
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifier)
        
    }
    
    static func scheduleCheckin(time: Int, sendMonthly: Bool) {
        
        scheduleDailyCheckin(reminderHour: time)
        
        if sendMonthly {
            
            scheduleMonthlyCheckin(reminderHour: time)
            
        }
    }
    
    private static func scheduleDailyCheckin(reminderHour: Int) {
        
        cancelCheckins(checkin: "Daily Check-in")
        let choreStore = ChoreStore()
        
        for each in choreStore.choreList {
            
            guard each.recurring == .none else {
                
                continue
                
            }
            
            let content = UNMutableNotificationContent()
            
            content.title = "Heads Up!"
            
            content.body = "You've got chores due today. Tap to view them"
            
            content.sound = UNNotificationSound(named: UNNotificationSoundName("ChoreAlert.wav"))
            
            var components = Calendar.current.dateComponents([.year, .month], from: each.due)
            
            components.hour = reminderHour
            
            components.minute = 0
     
            let id = UUID()
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "Daily Check-in\(id)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                if let error = error {
                    
                    print("Error scheduling check-in - \(error.localizedDescription)")
                    
                } else {
                    
                    print("Check-in scheduled successfully")
                    
                }
            }
        }
    }
    
    private static func scheduleMonthlyCheckin(reminderHour: Int) {
        
        cancelCheckins(checkin: "Monthly Check-in")
        
        let calendar = Calendar.current
        
        var monthsWithChores: Set<DateComponents> = []
        
        let choreStore = ChoreStore()
        
        for each in choreStore.choreList {
            
            guard each.recurring == .none else {
                
                continue
                
            }
            
            let components = calendar.dateComponents([.year, .month], from: each.due)
            
            monthsWithChores.insert(components)
            
        }
        
        for eachComponent in monthsWithChores {
            
            var components = DateComponents()
            
            components.year = eachComponent.year
            components.month = eachComponent.month
            
            components.day = 1
            
            components.hour = reminderHour
            
            components.minute = 0
            
            let id = UUID()
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let content = UNMutableNotificationContent()
            
            content.title = "Heads Up!"
            
            content.body = "You've got chores upcoming this month. Don't forget to check your list."
            
            content.sound = UNNotificationSound(named: UNNotificationSoundName("ChoreAlert.wav"))
            
            let request = UNNotificationRequest(identifier: "Monthly Check-in\(id)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                
                if let error = error {
                    
                    print("Could not schedule notification. \(error.localizedDescription)")
                    
                } else {
                    
                    print("Check in scheduled")
                    
                }
            }
        }
    }
    
    private static func cancelCheckins(checkin: String) {
        
        let center = UNUserNotificationCenter.current()
        
        center.getPendingNotificationRequests { requests in
            
            let matchingIds = requests.map { $0.identifier }.filter { $0.contains(checkin) }
            
            if !matchingIds.isEmpty {
                
                center.removePendingNotificationRequests(withIdentifiers: matchingIds)
                
                print("Successfully canceled checkins")
                
            } else {
                
                print("Nothing to cancel here")
                
            }
        }
    }
    
    static func updateBadgeCount(count: Int) {
        
        UNUserNotificationCenter.current().setBadgeCount(count) { error in
            
            if let error = error {
                
                print("There was an error setting the badge count. \(error)")
                
            } else {
                
                print("Badge count updated successfully")
                
            }
        }
    }
    
    static func getSuffixForNotifications(date: Int) -> String {
        
        var dateWithSuffix: String = ""
        
        switch(date) {
            
        case 1, 21, 31:
            dateWithSuffix = "st"
            
        case 2, 22:
            dateWithSuffix = "nd"
            
        case 3, 23:
            dateWithSuffix = "rd"
            
        default:
            dateWithSuffix = "th"
            
        }
        
        return "\(date)\(dateWithSuffix)"
        
    }
    
    static func getNotificationTitle(for recurrance: Repeating) -> String {
        
        var title: String = ""
        
        switch(recurrance) {
            
        case .none:
            title = "Chore Reminder"
            
        case .daily:
            title = "Daily Chore"
            
        case .weekly:
            title = "Weekly Chore"
            
        case .monthly:
            title = "Monthly Chore"
            
        }
        
        return title
        
    }
    
    static func getNotificationBody(for chore: String, at time: String, on date: Int, on weekday: Weekday, for recurrance: Repeating) -> String {
        
        var body: String = ""
        
        switch(recurrance) {
            
        case .none:
            body = "\(chore)at \(time)."
            
        case .daily:
            body = "\(chore). reminding you like you asked, every day at \(time)."
            
        case .weekly:
            body = "\(chore). Reminding you like you asked, every \(weekday.weekdayName) at \(time)."
            
        case .monthly:
            body = "\(chore). Reminding you like you asked, every month on the \(getSuffixForNotifications(date: date)) at \(time)"
            
        }
        return body
        
    }

}
