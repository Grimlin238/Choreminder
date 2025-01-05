/*
 MyChoreView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
*/

import SwiftUI

struct MyChoreView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    private var dueTodayView: some View {
        
        VStack {
            
            Text("Due Today")
            
            if choreStore.hasChoresDueToday() && choreStore.hasChoresWithNone() {
                
                List{
                    
                    ForEach(choreStore.choreList.filter { choreStore.isToday(day: $0.due) && $0.recurring == .none}) { chore in
                                
        NavigationLink(destination: EditChoreView(enjectedChore: chore.chore, enjectedDate: chore.due, enjectedTime: chore.at, enjectedRecursiveValue: chore.recurring)) {
                        
            Text("\(chore.chore). Due today at \(choreStore.toString_Time(date: chore.at))")
                .foregroundColor(.white)
                            }
        .buttonStyle(PlainButtonStyle())
        .listRowBackground(Color.indigo)
                        
                        
                        
                    }
                    
                    .onDelete {
                        indexSet in
                        indexSet.forEach { index in
                            
                            let chore = choreStore.choreList[index]
                            
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                            
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
            } else {
                
                Text("Nothing due today")
                
            }
        }
    }
    
    private var upComingChoresView: some View {
        
        VStack {
            
            Text("Upcoming this Month")
            
            if choreStore.isOccupiedMonth() && choreStore.hasChoresWithNone() {
                
                List {
                    
                    ForEach(choreStore.choreList.filter { !choreStore.isToday(day: $0.due) && choreStore.getMonthForStoredChore(date: $0.due) == choreStore.getCurrentMonth() && $0.recurring == .none } .prefix(10) ) { chore in
                        NavigationLink(destination: EditChoreView(enjectedChore: chore.chore, enjectedDate: chore.due, enjectedTime: chore.at, enjectedRecursiveValue: chore.recurring)) {
                            
                            Text("\(chore.chore). Due \(choreStore.toString_Date(date: chore.due)) at \(choreStore.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                        }
                        
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        
                    
                    }
                    
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            
                            let chore = choreStore.choreList[index]
                            
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                            
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            } else {
                
                Text("Nothing upcoming")
                
            }
        }
    }
    
    private var dailyChoreView: some View {
        
        VStack {
            
            Text("Daily Chores")
            
            if !choreStore.choreList.isEmpty && choreStore.hasDailyChores() {
                
                List {
                    
                    ForEach(choreStore.choreList.filter { $0.recurring == .daily}) { chore in
                        
                        NavigationLink(destination: EditChoreView(enjectedChore: chore.chore, enjectedDate: chore.due, enjectedTime: chore.at, enjectedRecursiveValue: chore.recurring)) {
                            
                            Text("\(chore.chore) -- Repeating daily at \(choreStore.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                        }
                        
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        
                    }
                    
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            
                            let chore = choreStore.choreList[index]
                            
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                                
                        }
                        
                    }
                    
                }
                .scrollContentBackground(.hidden)
            }else {
                
                Text("No daily Chores")
                
            }
        }
    }
    
    private var weeklyChoreView: some View {
        
        VStack {
            
            Text("Weekly chores")
            
            if choreStore.hasWeeklyChores() {
                
                List {
                    
                    ForEach(choreStore.choreList.filter { $0.recurring == .weekly }) { chore in
                        NavigationLink(destination: EditChoreView(enjectedChore: chore.chore, enjectedDate: chore.due, enjectedTime: chore.at, enjectedRecursiveValue: chore.recurring)) {
                            
                            Text("\(chore.chore) - repeating every \(choreStore.getWeekDayFor(date: chore.due)) at \(choreStore.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                        }
                        
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        
                        
                    }
                    
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            
                            let chore = choreStore.choreList[index]
                            
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            } else {
                
                Text("No weekly chores")
                
            }
        }
    }
    
    private var monthlyChoreView: some View {
        
        VStack {
            
            Text("Monthly Chores")
            
            if choreStore.hasMonthlyChores() {
                
                List {
                    
                    ForEach(choreStore.choreList.filter { $0.recurring == .monthly }){ chore in
                        
                        NavigationLink(destination: EditChoreView(enjectedChore: chore.chore, enjectedDate: chore.due, enjectedTime: chore.at, enjectedRecursiveValue: chore.recurring)) {
                            
                            Text("\(chore.chore) - repeating every month on the \(choreStore.getMonthSuffix(date: chore.due)) at \(choreStore.toString_Time(date: chore.at))")
                                .foregroundColor(.white)
                            
                        }
                        
                        .buttonStyle(PlainButtonStyle())
                        .listRowBackground(Color.indigo)
                        
                        
                    }
                    
                    .onDelete { indexSet in
                        
                        indexSet.forEach { index in
                            
                            let chore = choreStore.choreList[index]
                            
                            choreStore.removeFromChoreList(chore: chore.chore, due: chore.due, at: chore.at, recurring: chore.recurring)
                            
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            } else {
                
                Text("No monthly chores")
                
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("My Chores")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                
                dueTodayView
                
                upComingChoresView
                
                dailyChoreView
                
                weeklyChoreView
                
                monthlyChoreView
                
            }
            .background(Color.indigo)
            .foregroundColor(.white)
            
            .onAppear {
                
                choreStore.removePastChores()
                choreStore.sortChoreList()
                notificationManager.updateBadgeCount(count: 0)
                
            }
        }
    }
}

struct MyChoreView_preview: PreviewProvider {
    
    static var previews: some View {
        
        MyChoreView()
        
            .environmentObject(ChoreStore())
            .environmentObject(NotificationManager())
        
    }
}
