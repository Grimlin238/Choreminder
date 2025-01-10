/*
 MyChoreView.swift
 Part of Chore
 Tyian R. Lashley
 */

import SwiftUI

struct MyChoreView: View {
    @EnvironmentObject var choreStore: ChoreStore
    @EnvironmentObject var notificationManager: NotificationManager

    @State private var isTodayViewExpanded = true
    @State private var isUpcomingViewExpanded = false
    @State private var isDailyViewExpanded = false
    @State private var isWeeklyViewExpanded = false
    @State private var isMonthlyViewExpanded = false
    
    @AccessibilityFocusState private var focus: Bool

    private var todayView: some View {
        DisclosureGroup(
            isExpanded: $isTodayViewExpanded,
            content: {
                if choreStore.hasChoresDueToday() {
                    ForEach(choreStore.choreList.filter { choreStore.isToday(day: $0.due) && $0.recurring == .none }) { chore in
                        NavigationLink(
                            destination: EditChoreView(
                                enjectedChore: chore.chore,
                                enjectedDate: chore.due,
                                enjectedTime: chore.at,
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Due today at \(choreStore.toString_Time(date: chore.at))")
                                .padding()
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = choreStore.choreList[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                        }
                    }
                } else {
                    Text("Nothing due today")
                        .foregroundColor(.white)
                        .background(Color.indigo)
                        .italic()
                }
            },
            label: {
                Text("Due Today")
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
                        !choreStore.isToday(day: $0.due) &&
                        choreStore.getMonthForStoredChore(date: $0.due) == choreStore.getCurrentMonth()
                    }) { chore in
                        NavigationLink(
                            destination: EditChoreView(
                                enjectedChore: chore.chore,
                                enjectedDate: chore.due,
                                enjectedTime: chore.at,
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Due \(choreStore.toString_Date(date: chore.due)) at \(choreStore.toString_Time(date: chore.at))")
                                .padding()
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = choreStore.choreList[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
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
                Text("Upcoming This Month")
                    .foregroundColor(.white)
                    .background(Color.indigo)
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
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Repeats daily at \(choreStore.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = dailyChores[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                        }
                    }
                }
            },
            label: {
                Text("Daily Chores")
                    .foregroundColor(.white)
                    .background(Color.indigo)
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
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Repeats weekly on \(choreStore.getWeekDayFor(date: chore.due)) at \(choreStore.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = weeklyChores[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                        }
                    }
                }
            },
            label: {
                Text("Weekly Chores")
                    .foregroundColor(.white)
                    .background(Color.indigo)
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
                                enjectedRecursiveValue: chore.recurring
                            )
                        ) {
                            Text("\(chore.chore) - Repeats monthly on the \(choreStore.getMonthSuffix(date: chore.due)) at \(choreStore.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .listRowBackground(Color.indigo)
                        .accessibilityHint("Double tap to edit, or use the roter to delete this chore.")
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let chore = monthlyChores[index]
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                        }
                    }
                }
            },
            label: {
                Text("Monthly Chores")
                    .foregroundColor(.white)
                    .background(Color.indigo)
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
                notificationManager.updateBadgeCount(count: 0)
            }
        }
    }
}

struct MyChoreView_Preview: PreviewProvider {
    static var previews: some View {
        MyChoreView()
            .environmentObject(ChoreStore())
            .environmentObject(NotificationManager())
    }
}
