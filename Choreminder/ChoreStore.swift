/*
 ChoreStore.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 

import Foundation
import BackgroundTasks

class ChoreStore: ObservableObject {
    
    private var fileUrl: URL {
        
        let fileManager = FileManager.default
        
        let documentDirectories = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        let myDocumentDirectory = documentDirectories.first!
        
        let choreFileUrl = myDocumentDirectory.appendingPathComponent("chores.json")
        
        return choreFileUrl
        
    }
    
    @Published var choreList: [Chore] = []
    
    @Published var helpItems: [Help] = [
        Help(header: "Help", body: "Press next to move to the next help item. Press previous to go back. Tap done to leave healp."),
        Help(header: "Deleting a chore", body: "On the My Chores tab, swipe left on a chore, then tap delete."),
        Help(header: "Adding a chore", body: "Tap the create a chore tab, then type something you want to be reminded about, select when you want to be reminded and if it's recurring. When you're finished, tap save to chores."),
        Help(header: "Need Support? Gott a question or suggestion?", body: "Need a little help, or have questions/suggestions, tap done, then tap Get Support. You'll then be able to write an email to me.")
    ]
    
    let notificationManager = NotificationManager()
    
    init() {
        
        loadChores()
        
        
    }
    
    func addToChoreList(chore: String, due: Date, at: Date, recurring: Repeating, notificationIds: [String]) {
        
        choreList.append(Chore(chore: chore, due: due, at: at, recurring: recurring, notificationIds: notificationIds))
        
        saveChores()
        
    }
    
    func removeFromChoreList(chore: String, due: Date, at: Date, recurring: Repeating) {
        
        if let index = choreList.firstIndex(where: {
            
            $0.chore == chore && $0.due == due && $0.at == at && $0.recurring == recurring
            
        }) {
            
            let notificationIds = choreList[index].notificationIds
            
            notificationManager.cancelNotification(identifier: notificationIds)
            
            
            choreList.remove(at: index)
            
        }
        
        saveChores()
        
    }
    
    func removePastChores() {
        
        let currentDate = Date()
        
        
        for each in choreList {
            
            let oldDate = each.due
            
            if !isToday(day: each.due) && oldDate < currentDate && each.recurring != .daily && each.recurring != .monthly && each.recurring != .weekly {
                
                removeFromChoreList(chore: each.chore, due: each.due, at: each.at, recurring: each.recurring)
                
                let notificationIds = each.notificationIds
                
                notificationManager.cancelNotification(identifier: notificationIds)
                
                
            }
            
        }
        
        saveChores()
        
    }
    
    private func saveChores() {
        
        do {
            
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(choreList)
            
            try data.write(to: fileUrl)
            
        }
        
        catch {
            
            print("There was an issue detected in ChoreStore class. Issue: \(error)")
            
        }
        
    }
    
    private func loadChores() {
        
        do {
            
            let data = try Data(contentsOf: fileUrl)
            
            let decoder = JSONDecoder()
            
            choreList = try decoder.decode([Chore].self, from: data)
            
            
        }
        
        catch {
            
            print("Error loading tasks. issue: \(error)")
        }
        
    }
    
    func combine_Date(date: Date, time: Date) -> Date? {
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var combinedComponents = DateComponents()
        
        combinedComponents.year = dateComponents.year
        
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        
        combinedComponents.hour = timeComponents.hour
        
        combinedComponents.minute = timeComponents.minute
        
        combinedComponents.second = timeComponents.second
        
        return calendar.date(from: combinedComponents)
        
    }
    
    func toString_Date(date: Date) -> String {
        
        let formattedDate = DateFormatter()
        
        formattedDate.dateStyle = .medium
        
        formattedDate.timeStyle = .none
        
        return formattedDate.string(from: date)
        
    }
    
    func toString_Time(date: Date) -> String {
        
        let formattedTime = DateFormatter()
        
        formattedTime.dateStyle = .none
        
        formattedTime.timeStyle = .short
        
        return formattedTime.string(from: date)
        
    }
    
    func isToday(day: Date) -> Bool {
        
        let calendar = Calendar.current
        
        return calendar.isDateInToday(day)
        
    }
    
    func isBeginningOfMonth() -> Bool {
        
        let date = Date()
        
        let calendar = Calendar.current
        
        let isDayOne = calendar.component(.day, from: date)
        
        return isDayOne == 1
        
    }
    
    func sortChoreList() {
        
        choreList.sort { item1, item2 in
            
            let dateOne = combine_Date(date: item1.due, time: item1.at)
            
            let dateTwo = combine_Date(date: item2.due, time: item2.at)
            
            return dateOne ?? Date() < dateTwo ?? Date()
            
        }
        
    }
    
    func isChoreExist(chore: String, due: Date, at: Date, recurring: Repeating) -> Bool {
        
        for each in choreList {
            
            if chore == each.chore && due == each.due && at == each.at && recurring == each.recurring {
                
                return true
                
            }
        }
        
        return false
        
    }
    
    func hasChoresDueToday() -> Bool {
        
        for each in choreList {
            
            
            if isToday(day: each.due) {
                
                return true
                
            }
        }
        
        
        return false
        
    }
    
    func getCurrentMonth() -> String {
        
        let date = Date()
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM"
        
        let currentMonth = dateFormatter.string(from: date)
        
        return currentMonth
        
    }
    
    func getMonthForStoredChore(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM"
        
        let month = dateFormatter.string(from: date)
        
        return month
        
    }
    
    func isOccupiedMonth() -> Bool {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM"
        
        for each in choreList {
            
            
            let storedMonth = dateFormatter.string(from: each.due)
            
            if storedMonth == getCurrentMonth() && !isToday(day: each.due) {
                
                return true
                
            }
        }
        
        return false
        
    }
    
    func hasDailyChores() -> Bool {
        
        for each in choreList {
            
            if each.recurring == .daily {
                
                return true
                
            }
        }
        
        return false
        
    }
    
    func getWeekDayFor(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        var weekDayName: String = ""
        
        let calendar = Calendar.current
        let weekNumber = calendar.component(.weekday, from: date)
        
        weekDayName = dateFormatter.weekdaySymbols[weekNumber - 1]
        
        return weekDayName
        
    }
    
    func hasWeeklyChores() -> Bool {
        
        for each in choreList {
            
            if each.recurring == .weekly {
                
                return true
                
            }
        }
        
        return false
        
    }
    
    func getMonthSuffix(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        var dateWithSuffix: String = ""
        
        let calendar = Calendar.current
        
        let dayOfMonth = calendar.component(.day, from: date)
        
        let suffix: String
        
        switch(dayOfMonth) {
            
        case 1, 21, 31:
            suffix = "st"
            
        case 2, 22:
            suffix = "nd"
            
        case 3, 23:
            suffix = "rd"
            
        default:
            suffix = "th"
            
        }
        
        dateWithSuffix = "\(dayOfMonth)\(suffix)"
        
        return dateWithSuffix
        
    }
    
    func hasMonthlyChores() -> Bool {
        
        for each in choreList {
            
            if each.recurring == .monthly {
                
                return true
                
            }
        }
        
        return false
        
    }
    
    func hasChoresWithNone() -> Bool {
        
        for each in choreList {
            
            if each.recurring == .none {
                
                return true
                
            }
        }
        
        return false
        
    }
    
    func isTooCurrent(date: Date, time: Date, recurrance: Repeating) -> Bool {
        let calendar = Calendar.current
        
        guard let combinedDate = combine_Date(date: date, time: time) else {
            return false
        }
        
        let now = calendar.date(
            from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        )!
        
        let truncatedCombinedDate = calendar.date(
            from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: combinedDate)
        )!
        
        if recurrance == .none {
            
            return truncatedCombinedDate <= now
        }
        
        return false
    }
    
    func numChoresDueToday() -> Int {
        
        var counter = 0
        
        for each in choreList {
            
            if isToday(day: each.due) {
                
                counter += 1
                
            }
        }
        
        return counter
        
    }
       
}

