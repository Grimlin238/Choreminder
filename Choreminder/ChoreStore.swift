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
        Help(header: "The My Chores Screen", body: "The My Chores screen is where you'll see all of your Chores. Everything is broken into categories, Due Today, Upcoming This Month, Daily Chores, Weekly Chores, and Monthly Chores. \n The Due Today category is always opened for you, and you can tap to expand the others as well.\nNote: Repeating chores will not show up in the due today category."),
        Help(header: "Deleting a Chore", body: "To delete a Chore, tap on a Chore category to expand it. Then, simply swipe left on the Chore you'd like to delete and tap the Delete button that appears to the right of it.\nAlternatively, you can tap on the Chore and tap Delete from the edit screen that appears and confirm deletion."),
        Help(header: "Editing a Chore", body: "To edit a Chore, expand one of the Chore categories. Then tap on the Chore you'd like to edit. An edit screen will appear allowing you to perform your changes.\nWhen you're done, tap Save Edit and confirm your changes. YOu'll then be brought back to the My Chores screen, and you'll imediately see the change."),
        Help(header: "Marking Chores as Complete / Incomplete", body: "The due today category will show you everything that's due today. To mark a Chore as complete, swipe right on the CHore and tap Mark as Complete. To undo, swipe right and tap Mark as incomplete\nChores switch from red to yellow when marked as complete.\nNote: Since daily, weekly, and monthly chores are recurring, and upcoming only show incoming chores, you can't mark them as complete."),
        Help(header: "Creating a Chore", body: "At the bottom of the screen, tap New CHore. A Chore creation screen will appear allowing you to enter a chore, after which you can select a date you'd like to be reminded on, and a time. When done, tap Add to My Chores"),
        Help(header: "Scheduling a Daily Chore", body: "One of the amazing features of Chore is its granularity. This means you can schedule daily, weekly, and monthly Chores.\nTo schedule a daily chore, tap New Chore at the bottom of the screen. Then, enter a Chore in the text box. Next, tap to open the frequency picker to select daily. Afterwords, select a time from the time picker and tap Add to My Chores. Chore will then remind you everyday at the time you selected."),
        Help(header: "Scheduling a Weekly Chore", body: "You can use Chore to remind you to do things weekly, like taking out the trash, or of a due date for an assignment.\nTap New CHore at the bottom of the screen, enter a chore, then open the frequency picker and select weekly.\nNext, open the weekday picker and select a day of the week. Afterwords, select a time from the time picker, and tap Add to My Chores. Chore will then remind you on the selected weekday at the selected time."),
        Help(header: "Scheduling a Monthly Chore", body: "You can use Chore to set monthly reminders as well.\nTap New Chore at the bottom of the screen. Then, enter a CHore. From the frequency picker, select monthly. Afterwords, open the date picker and select a date from 1 to 31. When done, select a time from the time picker and tap Add to My Chores. Chore will then remind you every month on te selected date at the selected time.\nNote: If you select a date that's at the end of the month and an upcoming month does not have that date i.e. you select 31, but the next month only has 30 or 28 days, Chore will just remind you on the last day of that month, so there's nothing you have to worry about."),
        Help(header: "Reminding you to Open the App Everyday", body: "Chore can remind you to open the app everyday. Sometimes, we need a nudge, and Chore is here to do exactly that.\nTap more, then Settings. In settings, you can adjust the Remind me everyday at, insert time, A.M. of chores I have upcoming foer the day., picker from 5:00AM to 11:00AM.\nNote: Chore won't remind you of chores you have upcoming for the day if they're recurring. It will only do this for regular reminders. This is to prevent redundancy."),
        Help(header: "Reminding you of Upcoming Chores for the Current Month", body: "Chore can remind you to open the app and view your upcoming chores for the current month. The setting is off by default, but you can turn it on by tapping More, Settings, and toggling, Remind me at the beginning of every month of upcoming chores for that month., to on."),
        Help(header: "Getting Help", body: "You can always get help with common features of Chore by tapping more, Help, and selecting one of the help categories.\nIf you need more support, tap More, Get Support, then Get support to send an email. Don't forget to do your chores. :-)")
    ]
    
    @Published var welcomeScreens: [Welcome] = [
        
        Welcome(title: "Welcome to Chore", body: "This is chore, an app reminding you to get things done."),
        Welcome(title: "All Your Chores at a Glance", body: "See all of your chores due today at a glance, and expand the other sections to view thoughs as well."),
        Welcome(title: "Schedule Any Kind of Chore.", body: "Whether you want to be reminded once, everyday, every week or month, Chore has got you covered."),
        Welcome(title: "A Nudge Every Morning", body: "If you've got stuff to do today, Chore will remind you in the morning to open the app. YOu can also change the time CHore nudges you as well in settings."),
        Welcome(title: "An Easy to Use Interface", body: "Chore was made to be as simple as possible. Tap a Chore to edit or delete it, swipe left to delete, swipe right on things due today to mark/unmark as complete, and diferent screens like My Chores, and Create a CHore are on different tabs, allowing you to switch back and forth with ease."),
        Welcome(title: "Quick Question! What are you Waiting For?", body: "Tap Get Started and begin making your chore list. :-)")
        
    ]
    
    init() {
        
        loadChores()
        
        
    }
    
    func addToChoreList(chore: String, due: Date, at: Date, weekday: Weekday, date: Int, recurring: Repeating, didComplete: Bool, notificationIds: [String]) {
        
        var adjustedDate = due
        
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .day, .month, .weekday], from: adjustedDate)
        
        if recurring == .weekly {
            
            let matchingComponents = DateComponents()
            
            if let nextWeeklyDueDate = calendar.nextDate(after: calendar.startOfDay(for: Date()), matching: matchingComponents, matchingPolicy: .nextTime, direction: .forward) {
                adjustedDate = nextWeeklyDueDate
                
            }
        }
        
        if recurring == .monthly {
            
            components.day = date
            
        }
        
        if let newDue = calendar.date(from: components) {
            
            choreList.append(Chore(chore: chore, due: newDue, at: at, weekday: weekday, date: date, recurring: recurring, didComplete: false, notificationIds: notificationIds))
            print("Stored chore for date \(newDue)")
            
        }
        
        saveChores()
        
    }
    
    func removeFromChoreList(chore: String, due: Date, at: Date, weekday: Weekday, date: Int, recurring: Repeating) {
        
        if let index = choreList.firstIndex(where: {
            
            $0.chore == chore && $0.due == due && $0.at == at && $0.weekday == weekday && $0.date == date && $0.recurring == recurring
            
        }) {
            
            let notificationIds = choreList[index].notificationIds
            
            NotificationManager.cancelNotification(identifier: notificationIds)
            
            choreList.remove(at: index)
            
        }
        
        saveChores()
        
    }
    
    func removePastChores() {
        
        let currentDate = Date()
        
        for each in choreList {
            
            let oldDate = each.due
            
            if !DateManager.isToday(day: each.due) && oldDate < currentDate && each.recurring != .daily && each.recurring != .monthly && each.recurring != .weekly {
                
                removeFromChoreList(chore: each.chore, due: each.due, at: each.at, weekday: each.weekday, date: each.date, recurring: each.recurring)
                
                let notificationIds = each.notificationIds
                
                NotificationManager.cancelNotification(identifier: notificationIds)
                
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
        
        func sortChoreList() {
            
            choreList.sort { item1, item2 in
                
                let dateOne = DateManager.combine_Date(date: item1.due, time: item1.at)
                
                let dateTwo = DateManager.combine_Date(date: item2.due, time: item2.at)
                
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
                
                
                if DateManager.isToday(day: each.due) {
                    
                    return true
                    
                }
            }
            
            return false
            
        }
        
        func isOccupiedMonth() -> Bool {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "MMM"
            
            for each in choreList {
                
                let storedMonth = dateFormatter.string(from: each.due)
                
                if storedMonth == DateManager.getCurrentMonth() && !DateManager.isToday(day: each.due) && each.recurring != .daily && each.recurring != .weekly && each.recurring != .monthly {
                    
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
        
        func hasWeeklyChores() -> Bool {
            
            for each in choreList {
                
                if each.recurring == .weekly {
                    
                    return true
                    
                }
            }
            
            return false
            
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
        
        func numChoresDueToday() -> Int {
            
            var counter = 0
            
            for each in choreList {
                
                if DateManager.isToday(day: each.due) && each.recurring == .none {
                    
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
                
                if storedMonth == DateManager.getCurrentMonth() && !DateManager.isToday(day: each.due) && each.recurring != .daily && each.recurring != .weekly && each.recurring != .monthly {
                    
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
    
    func markAsComplete(chore: String, due: Date, at: Date, recurring: Repeating) {
        
        if let id = choreList.firstIndex(where: {
            
            $0.chore == chore && $0.due == due && $0.at == at && $0.recurring == recurring
            
        }) {
            
            choreList[id].didComplete = true
            
        }
    }
    
    func markAsIncomplete(chore: String, due: Date, at: Date, recurring: Repeating) {
        
        if let id = choreList.firstIndex(where: {
            
            $0.chore == chore && $0.due == due && $0.at == at && $0.recurring == recurring
            
        }) {
            
            choreList[id].didComplete = false
            
        }
    }
    }
