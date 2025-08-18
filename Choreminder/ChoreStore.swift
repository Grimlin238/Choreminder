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
        Help(header: "The My Chores Screen", body: "The My Chores screen is where you'll see all of your upcoming chores. Everything is broken into categories, Due Today, Upcoming This Month, Daily Chores, Weekly Chores, and Monthly Chores. \n The Due Today category is always opened for you, and you can tap to expand the others as well."),
        Help(header: "Deleting a Chore", body: "To delete a Chore, tap on a Chore category to expand it. Then, simply swipe left on the Chore you'd like to delete and tap the Delete button that appears to the right of it.\nAlternatively, you can tap on the Chore and tap Delete from the edit screen that appears and confirm deletion."),
        Help(header: "Editing a Chore", body: "To edit a Chore, expand one of the Chore categories. Then tap on the Chore you'd like to edit. An edit screen will appear allowing you to perform your changes.\nWhen you're done, tap Save Edit aned confirm your changes. YOu'll then be brought back to the My Chores screen, and you'll imediately see the change."),
        Help(header: "Creating a Chore", body: "At the bottom of the screen, tap New CHore. A Chore creation screen will appear allowing you to enter a chore, after which you can select a date you'd like to be reminded on, and a time. When done, tap Add to My Chores"),
        Help(header: "Scheduling a Daily Chore", body: "One of the amazing features of Chore is its granularity. This means you can schedule daily, weekly, and monthly Chores.\nTo schedule a daily chore, tap New Chore at the bottom of the screen. Then, enter a Chore in the text box. Next, tap to open the frequency picker to select daily. Afterwords, select a time from the time picker and tap Add to My Chores. Chore will then remind you everyday at the time you selected."),
        Help(header: "Scheduling a Weekly Chore", body: "You can use Chore to remind you to do things weekly, like taking out the trash, or of a due date for an assignment.\nTap New CHore at the bottom of the screen, enter a chore, then open the frequency picker and select weekly.\nNext, open the weekday picker and select a day of the week. Afterwords, select a time from the time picker, and tap Add to My Chores. Chore will then remind you on the selected weekday at the selected time."),
        Help(header: "Scheduling a Monthly Chore", body: "You can use Chore to set monthly reminders as well.\nTap New Chore at the bottom of the screen. Then, enter a CHore. From the frequency picker, select monthly. Afterwords, open the date picker and select a date from 1 to 31. When done, select a time from the time picker and tap Add to My Chores. Chore will then remind you every month on te selected date at the selected time.\nNote: If you select a date that's at the end of the month and an upcoming month does not have that date i.e. you select 31, but the next month only has 30 or 28 days, Chore will just remind you on the last day of that month, so there's nothing you have to worry about."),
        Help(header: "Reminding you to Open the App Everyday", body: "Chore can remind you to open the app everyday. Sometimes, we need a nudge, and Chore is here to do exactly that.\nTap more, then Settings. In settings, you can adjust the Remind me everyday at, insert time, A.M. of chores I have upcoming foer the day., picker from 5:00AM to 11:00AM.\nNote: Chore won't remind you of chores you have upcoming for the day if they're recurring. It will only do this for regular reminders. This is to prevent redundancy.\nNote: Do to iOS system limitations, Chore might remind you later then expected. If you aren't using Chore frequently, iOS will not prioritize Chore."),
        Help(header: "Reminding you of Upcoming Chores for the Current Month", body: "Chore can remind you to open the app and view your upcoming chores for the current month. The setting is off by default, but you can turn it on by tapping More, Settings, and toggling, Remind me at the beginning of every month of upcoming chores for that month., to on. Note: Do to iOS system limitations, Chore might remind you later then expected. If you aren't using Chore frequently, iOS will not prioritize Chore."),
        Help(header: "Getting Help", body: "You can always get help with common features of Chore by tapping more, Help, and selecting one of the help categories.\nIf you need more support, tap More, Get Support, then Get support to send an email. Don't forget to do your chores. :-)")
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
            
            let matchingComponents = DateComponents()
            
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
        
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.teelashley.chore.apprefresh", using: nil) { task in
            if let task = task as? BGAppRefreshTask {
                self.handleAppRefresh(task: task)
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
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        
        let operation = Task {
            print("Starting background task")
    
            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
            
            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
            
            let numBadges = numChoresDueToday()
            notificationManager.updateBadgeCount(count: numBadges)
            
            if numBadges == 0 && !sendMonthly {
                
                print("No operations needed. Exiting task")
                scheduleAppRefreshTask(time: reminderHour)
                task.setTaskCompleted(success: true)
                
            } else {
                
                removePastChores()
                
                if choreList.count == 1 || choreList.count > 1 {
                    
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
                    
                    if isBeginningOfMonth() && isOccupiedMonth() {
                        
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
        removePastChores()
        let numBadges = numChoresDueToday()
        notificationManager.updateBadgeCount(count: numBadges)
    }
    
    func cancelBackgroundTask() {
        
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.teelashley.chore.apprefresh")
        
    }
}
