/*
 MyChoreView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley
 All rights reserved.
 */

import SwiftUI

struct MyChoreView: View {
    @EnvironmentObject var choreStore: ChoreStore
    @State private var isTodayViewExpanded = true
    @State private var isUpcomingViewExpanded = false
    @State private var isDailyViewExpanded = false
    @State private var isWeeklyViewExpanded = false
    @State private var isMonthlyViewExpanded = false
    
    @AccessibilityFocusState private var focus: Bool
    
    @State private var numDueToday = 0
    
    @State private var numUpcoming = 0
    
    @State private var numDaily = 0
    
    @State private var numWeekly = 0
    
    @State private var numMonthly = 0

    private var todayView: some View {
        DisclosureGroup(
            isExpanded: $isTodayViewExpanded,
            content: {
                if choreStore.hasChoresDueToday() {
                    ForEach(choreStore.choreList.filter { DateManager.isToday(day: $0.due) && $0.recurring == .none }) { chore in
                        NavigationLink(
                            destination: EditChoreView(
                                enjectedChore: chore.chore,
                                enjectedDate: chore.due,
                                enjectedTime: chore.at,
                                enjectedWeekday: chore.weekday,
                                enjectedMonthDate: chore.date,
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Due today at \(DateManager.toString_Time(date: chore.at))")
                                .padding()
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = choreStore.choreList[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, weekday: chore.weekday, date: chore.date, recurring: chore.recurring)
                            
                            numDueToday -= 1
                            
                            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
                            
                            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
                            
                            NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendMonthly)
                            
                        }
                    }
                } else {
                    Text("Nothing due today")
                        .foregroundColor(.white)
                        .background(Color.indigo)
                        .font(.title)
                        .fontWeight(.bold)
                        .italic()
                }
            },
            label: {
                Text("Due Today: \(numDueToday)")
                    .foregroundColor(.white)
                    .background(Color.indigo)
                    .padding()
            }
        )
    }

    private var upcomingView: some View {
        DisclosureGroup(
            isExpanded: $isUpcomingViewExpanded,
            content: {
                if choreStore.isOccupiedMonth() {
                    ForEach(choreStore.choreList.filter {
                        !DateManager.isToday(day: $0.due) &&
                        DateManager.getMonthForStoredChore(date: $0.due) == DateManager.getCurrentMonth() && $0.recurring != .daily && $0.recurring != .weekly && $0.recurring != .monthly
                    }) { chore in
                        NavigationLink(
                            destination: EditChoreView(
                                enjectedChore: chore.chore,
                                enjectedDate: chore.due,
                                enjectedTime: chore.at,
                                enjectedWeekday: chore.weekday,
                                enjectedMonthDate: chore.date,
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Due \(DateManager.toString_Date(date: chore.due)) at \(DateManager.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                                
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = choreStore.choreList[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, weekday: chore.weekday, date: chore.date, recurring: chore.recurring)
                            
                            numUpcoming -= 1
                            
                            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
                            
                            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
                            
                            NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendMonthly)
                            
                        }
                    }
                } else {
                    Text("Nothing upcoming this month")
                        .foregroundColor(.white)
                        .background(Color.indigo)
                        .italic()
                }
            },
            label: {
                Text("Upcoming This Month: \(numUpcoming)")
                    .foregroundColor(.white)
                    .background(Color.indigo)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
        )
    }

    private var dailyView: some View {
        DisclosureGroup(
            isExpanded: $isDailyViewExpanded,
            content: {
                let dailyChores = choreStore.choreList.filter { $0.recurring == .daily }
                if dailyChores.isEmpty {
                    Text("No daily chores")
                        .foregroundColor(.white)
                        .background(Color.indigo)
                        .italic()
                } else {
                    ForEach(dailyChores) { chore in
                        NavigationLink(
                            destination: EditChoreView(
                                enjectedChore: chore.chore,
                                enjectedDate: chore.due,
                                enjectedTime: chore.at,
                                enjectedWeekday: chore.weekday,
                                enjectedMonthDate: chore.date,
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Repeats daily at \(DateManager.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = dailyChores[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, weekday: chore.weekday, date: chore.date, recurring: chore.recurring)
                            
                            numDaily -= 1
                            
                            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
                            
                            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
                            
                            NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendMonthly)
                            
                        }
                    }
                }
            },
            label: {
                Text("Daily Chores: \(numDaily)")
                    .foregroundColor(.white)
                    .background(Color.indigo)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
        )
    }

    private var weeklyView: some View {
        DisclosureGroup(
            isExpanded: $isWeeklyViewExpanded,
            content: {
                let weeklyChores = choreStore.choreList.filter { $0.recurring == .weekly }
                if weeklyChores.isEmpty {
                    Text("No weekly chores")
                        .foregroundColor(.white)
                        .background(Color.indigo)
                        .italic()
                } else {
                    ForEach(weeklyChores) { chore in
                        NavigationLink(
                            destination: EditChoreView(
                                enjectedChore: chore.chore,
                                enjectedDate: chore.due,
                                enjectedTime: chore.at,
                                enjectedWeekday: chore.weekday,
                                enjectedMonthDate: chore.date,
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Repeats weekly on \(DateManager.getWeekDayFor(date: chore.due))'s at \(DateManager.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = weeklyChores[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, weekday: chore.weekday, date: chore.date, recurring: chore.recurring)
                            
                            numWeekly -= 1
                            
                            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
                            
                            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
                            
                            NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendMonthly)
                            
                        }
                    }
                }
            },
            label: {
                Text("Weekly Chores: \(numWeekly)")
                    .foregroundColor(.white)
                    .background(Color.indigo)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
        )
    }

    private var monthlyView: some View {
        DisclosureGroup(
            isExpanded: $isMonthlyViewExpanded,
            content: {
                let monthlyChores = choreStore.choreList.filter { $0.recurring == .monthly }
                if monthlyChores.isEmpty {
                    Text("No monthly chores")
                        .foregroundColor(.white)
                        .background(Color.indigo)
                        .italic()
                } else {
                    ForEach(monthlyChores) { chore in
                        NavigationLink(
                            destination: EditChoreView(
                                enjectedChore: chore.chore,
                                enjectedDate: chore.due,
                                enjectedTime: chore.at,
                                enjectedWeekday: chore.weekday,
                                enjectedMonthDate: chore.date,
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Repeats monthly on the \(DateManager.getMonthSuffix(date: chore.due)) at \(DateManager.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding()
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = monthlyChores[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, weekday: chore.weekday, date: chore.date, recurring: chore.recurring)
                            
                            numMonthly -= 1
                            
                            let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
                            
                            let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
                            
                            NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendMonthly)
                        }
                    }
                }
            },
            label: {
                Text("Monthly Chores: \(numMonthly)")
                    .foregroundColor(.white)
                    .background(Color.indigo)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            }
        )
    }

    private var choreListView: some View {
        List {
            todayView
                .listRowBackground(Color.indigo)
            
            upcomingView
                .listRowBackground(Color.indigo)
            
            dailyView
                .listRowBackground(Color.indigo)
            
            weeklyView
                .listRowBackground(Color.indigo)
            
            monthlyView
                .listRowBackground(Color.indigo)
        }
        .scrollContentBackground(.hidden)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("My Chores")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityFocused($focus)
                
                Spacer()
                choreListView
            }
            .background(Color.indigo)
            .foregroundColor(.white)
            .onAppear {
                focus = true
                choreStore.removePastChores()
                choreStore.sortChoreList()
             
                NotificationManager.updateBadgeCount(count: 0)
                numDueToday = choreStore.numChoresDueToday()
                
                numUpcoming = choreStore.numUpComing()
                
                numDaily = choreStore.numDaily()
                
                numWeekly = choreStore.numWeekly()
                
                numMonthly = choreStore.numMonthly()
                
            }
        }
    }
}

struct MyChoreView_Preview: PreviewProvider {
    static var previews: some View {
        MyChoreView()
            .environmentObject(ChoreStore())
    }
}
