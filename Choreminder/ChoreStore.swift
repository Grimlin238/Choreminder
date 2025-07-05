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
        Help(header: "My Chores", body: "Every time the app opens, you'll be brought to the My Chores tab. The Due Today section is automatically expanded every time the view appears. You can collapse it, and tap to expand the other sections, upcoming, daily, weekly,and monthly as well."),
        Help(header: "Deleting a Chore.", body: "Chore will automatically remove past due Chores for you, so you don't need to worry about them. Don't need the chore, and want to remove it anyway? Just swipe left and tap delete."),
        Help(header: "Editing a Chore", body: "Need to change the due date, time, or recurrance? Just tap the chore, make your changes and tap Save Edit. You can also tap Delete Chore to get rid of it as well."),
        Help(header: "Creating a Chore", body: "So you want to create a chore? Just tap the Create a chore tab. Next, type what you want to be reminded about, set a due date, time, and leave repeating as none if you don't want the chore to repeatedly remind you. When finished, tap Add To Chores."),
        Help(header: "Scheduling a Daily Chore", body: "Got medication you need to be reminded about? Or maybe you need to be told to take the dog out each morning. On the Create a Chore Tab, type in the thing you want to be reminded about, select a time, and tap repeating. When the pop-up appears, tap daily, then tap Add to Chores. Chore will then remind you every day at the selected time."),
        Help(header: "Scheduling Weekly Chores", body: "One of the cool things about Chore is that you can have it remind you on specific weekdays to do things. When creating a chore, in the date selection, just select any day that has the day you're looking for, a time, and weekly from repeating, and let Chore do the rest. Example: Want to be reminded every Saturday, tap a date that has a Saturday in it, and Chore will do the rest."),
        Help(header: "Scheduling a Monthly Chore", body: "Want to be reminded to pay your credit card bill, rent, or go to the doctor every month? Chore has got you covered. Similar to weekly scheduling, select any date that has the day you're looking for, monthly from repeating, and let Chore do the rest. Example, want to be reminded every 2nd of the month, select any date that has a 2nd, and Chore will handle it from there."),
        Help(header: "Reminding you to Open the App Everyday", body: "If you've chores due today, Chore will remind you to open the app and view them. Want to set a time of day you'd like that to happen, tap more, then settings, and use the stepper to choose between 5:00 A.M. and 11:00 A.M.. Note: do to iOS system limitations, this might occur later than the time you selected."),
        Help(header: "Being Reminded of Chores for the Current Month", body: "In settings, set remind me of chores I have upcoming for the current month to on if you want chore to perform this action. It'll happen at the same time you asked chore to remind you of upcoming chores for the day, but once a month. Note: Do to iOS system limitations, Chore might remind you later than expected."),
        Help(header: "Don't Know how to Use the App", body: "Tap More, then tutorial to learn how to use Chore. Oh, wait! You're already here."),
        Help(header: "Need support? Have Feedback?", body: "Tap More, then Get Support to get help."),
        Help(header: "And That's It!", body: "ANd that's all you need to know about using Chore. You can always come back here if you need a reminder. See you later, and don't forget to do your chores.")
    ]
    
    @Published var welcomeScreens: [Welcome] = [
        
        Welcome(title: "Welcome to Chore", body: "This is chore, an app reminding you to get things done."),
        Welcome(title: "All Your Chores at a Glance", body: "See all of your chores due today at a glance, and expand the other sections to view thoughs as well."),
        Welcome(title: "Schedule Any Kind of Chore.", body: "Whether you want to be reminded once, everyday, every week or month, Chore has got you covered."),
        Welcome(title: "An Easy to Use Interface", body: "Want to delete a Chore? Just swipe left and tap delete. Want to edit the Chore? Just tap on it. It's as simple as that."),
        Welcome(title: "Adding a Chore?", body: "Tap New Chore, type a chore, select a date and time, and tap Add to Chores. See? Easy."),
        Welcome(title: "Want Daily Chores?", body: "No Problem. Type the chore, select daily, a time, and let Chore do the rest."),
        Welcome(title: "Want Weekly Chores?", body: "Like I said. No Problem. Type a chore, tap any date with the day you're looking to be reminded on weekly, and let CHore do the rest."),
        Welcome(title: "Want Monthly Chores?", body: "I've got you man! Type a chore, select any date with the day you're looking to be reminded monthly on, and let Chore do the rest."),
        Welcome(title: "Quick Question. What are You Waiting For?", body: "Tap next and get started with Chore. Have questions or feedback? No worries. Support is only a few taps away. Now go do your chores, like your parents tole you! :-)")
    ]
    
    let notificationManager = NotificationManager()
    
    init() {
        
        loadChores()
        
        
    }
    
    func addToChoreList(chore: String, due: Date, at: Date, weekday: Weekday, date: Int, recurring: Repeating, notificationIds: [String]) {
        
        var adjustedDate = due
        
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .day, .month, .weekday], from: adjustedDate)
        
            if recurring == .weekly {
                     
                    var matchingComponents = DateComponents()
                    
                    if let nextWeeklyDueDate = calendar.nextDate(after: calendar.startOfDay(for: Date()), matching: matchingComponents, matchingPolicy: .nextTime, direction: .forward) {
                        adjustedDate = nextWeeklyDueDate
                        
                    }
                }
                
        if recurring == .monthly {
            
            components.day = date
            
        }
        
        if let newDue = calendar.date(from: components) {
            
            choreList.append(Chore(chore: chore, due: newDue, at: at, weekday: weekday, date: date, recurring: recurring, notificationIds: notificationIds))
            print("Stored chore for date \(newDue)")
            
        }
        
        saveChores()
        
    }
    
    func removeFromChoreList(chore: String, due: Date, at: Date, weekday: Weekday, date: Int, recurring: Repeating) {
        
        if let index = choreList.firstIndex(where: {
            
            $0.chore == chore && $0.due == due && $0.at == at && $0.weekday == weekday && $0.date == date && $0.recurring == recurring
            
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
                
                removeFromChoreList(chore: each.chore, due: each.due, at: each.at, weekday: each.weekday, date: each.date, recurring: each.recurring)
                
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
    
    func isChoreExist(chore: String, due: Date, at: Date, weekday: Weekday, date: Int, recurring: Repeating) -> Bool {
        
        for each in choreList {
            
            if chore == each.chore && due == each.due && at == each.at && weekday == each.weekday && date == each.date && recurring == each.recurring {
                
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
            
            if storedMonth == getCurrentMonth() && !isToday(day: each.due) && each.recurring != .daily && each.recurring != .weekly && each.recurring != .monthly {
                
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
            
            if isToday(day: each.due) && each.recurring == .none {
                
                counter += 1
                
            }
        }
        
        return counter
        
    }
    
    func numUpComing() -> Int {
        
        var counter = 0
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM"
        
        for each in choreList {
            
            let storedMonth = dateFormatter.string(from: each.due)
            
            if storedMonth == getCurrentMonth() && !isToday(day: each.due) && each.recurring != .daily && each.recurring != .weekly && each.recurring != .monthly {
                
                counter += 1
            }
        }
        
        return counter
        
    }
    
    func numDaily() -> Int {
        
        var counter = 0
        
        for each in choreList {
            
            if each.recurring == .daily {
                
                counter += 1
                
            }
            
        }
            
            return counter
            
        }
        
        func numWeekly() -> Int {
            
            var counter = 0
            
            for each in choreList {
                
                if each.recurring == .weekly {
                    
                    counter += 1
                    
                }
                
            }
                
                return counter
                
            }
            
            func numMonthly() -> Int {
                
                var counter = 0
                
                for each in choreList {
                    
                    if each.recurring == .monthly {
                        
                        counter += 1
                        
                    }
                    
                }
                    
                    return counter
                    
                }
            
}
