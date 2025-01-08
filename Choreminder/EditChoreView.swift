/*
 EditChoreView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 
import SwiftUI

struct EditChoreView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    
    @EnvironmentObject var notificationManager: NotificationManager
    
    @Environment(\.dismiss) private var dismiss
    
    @State var enjectedChore: String
    @State private var selectedDate: Date
    @State private var selectedTime: Date
    @State var enjectedRecursiveValue: Repeating = .none
    @State private var showDeleteAlert = false
    
    @State private var showEditAlert = false
    
    @State private var oldChore = ""
    
    @State private var oldDate = Date()
    
    @State private var oldTime = Date()
    
    @State private var oldRecursiveValue: Repeating = .none
    
    @State private var isChoreExisting = false
    
    @FocusState private var isFocused: Bool
    
    init(enjectedChore: String = "Default", enjectedDate: Date = Date(), enjectedTime: Date = Date(), enjectedRecursiveValue: Repeating = .none) {
        
        _enjectedChore = State(initialValue: enjectedChore)
        _selectedDate = State(initialValue: enjectedDate)
        _selectedTime = State(initialValue: enjectedTime)
        _enjectedRecursiveValue = State(initialValue: enjectedRecursiveValue)
    }
    
    private var textFieldView: some View {
        
        VStack {
            
            Spacer()
            
            TextField("Enter Updated Chore", text: $enjectedChore)
            
                .focused($isFocused)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
                .toolbar {
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        
                        Spacer()
                        
                        Button("Done") {
                            
                            isFocused = false
                            
                        }
                    }
                }
            
        }
        .padding()
    }
    
    private var dateSelectionView: some View {
        
        VStack {
            
            DatePicker("Select a date",
                       selection: $selectedDate,
                       in: Date()...,
                       displayedComponents: .date)
            .datePickerStyle(.compact)
            .background(Color.white)
            .foregroundColor(.black)
            Spacer()
        }
        .cornerRadius(10)
        .padding()
    }
    
    private var timeSelectionView: some View {
        
        VStack {
            
            DatePicker("Choose a time",
                       selection: $selectedTime,
                       displayedComponents: .hourAndMinute)
            .datePickerStyle(.compact)
            .background(Color.white)
            Spacer()
        }
        .cornerRadius(10)
        .padding()
        
    }
    
    private var recurssionView: some View {
        
        VStack {
            
            Picker("Repeating?", selection:  $enjectedRecursiveValue) {
                
                ForEach(Repeating.allCases, id: \.self) { recurrance in
                    
                    Text(recurrance.rawValue)
                    
                }
            }
            
            .pickerStyle(.menu)
            .background(Color.white)
            .foregroundColor(.black)
            Spacer()
        }
        .cornerRadius(10)
        .padding()
    }
    
    private var deleteAndEditButtonView: some View {
        
        HStack(spacing: 16) {
            
            Button("Save Edit") {
                
                updateChore()
                
            }
            .disabled(enjectedChore.isEmpty || enjectedChore == " " || choreStore.isTooCurrent(date: selectedDate, time: selectedTime, recurrance: enjectedRecursiveValue))
            .buttonStyle(PlainButtonStyle())
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding()
            
            .alert(isPresented: $showEditAlert) {
                
                if isChoreExisting {
                    
                    return Alert(
                        
                    title: Text("Chore already exists"),
                        
                    message: Text("That chore already exists."),
                        
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    
                    return Alert(
                        
                        title: Text("Save edit?"),
                    
                                 message: Text("You are about to edit your chore. This action can't be undone"),
                    
                                 primaryButton: .destructive(Text("Save Edit")) {
                              
                        dismiss()
                        
                    },
                    
                                 secondaryButton: .cancel()
                                 
                    )
                }
            }
            
            Button("Delete Chore") {
                
                showDeleteAlert = true
                
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: 44)
            .padding()
            
            .alert("Are you sure?", isPresented: $showDeleteAlert) {
                
                Button("Cancel", role: .cancel) { }
                
                Button("Yes, I'm Sure.", role: .destructive) {
                    
                    choreStore.removeFromChoreList(chore: oldChore, due: oldDate, at: oldTime, recurring: oldRecursiveValue)
                    
                    dismiss()
                    
                }
                
            }
                
                message: {
                    
                    Text("Deleting this chore will remove it from your chore list. This action can't be undone.")
                    
                }
            
        }
        .padding(.horizontal)
        
        .frame(maxWidth: .infinity, maxHeight: 44)
    }
 
    var body: some View {
        
        VStack(spacing: 16) {
            
            textFieldView
                .padding(.horizontal, 16)
            
            dateSelectionView
                .padding(.horizontal, 16)
            
            timeSelectionView
                .padding(.horizontal, 16)
            
            recurssionView
                .padding(.horizontal, 16)
            
Spacer()
            deleteAndEditButtonView
            
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Edit Chore")
        
        .onAppear {
            
            oldChore = enjectedChore
            
            oldDate = selectedDate
            
            oldTime = selectedTime
            
            oldRecursiveValue = enjectedRecursiveValue
            
        }
        
    }
    
    private func updateChore() {
        
        let hasChore = choreStore.isChoreExist(chore: enjectedChore, due: selectedDate, at: selectedTime, recurring: enjectedRecursiveValue)
        
        if !hasChore {
            
            var adjustedDate = selectedDate
            
            if enjectedRecursiveValue == .daily {
                
                adjustedDate = Calendar.current.startOfDay(for: Date())
                
                if let adjustedTime = Calendar.current.date(bySettingHour:Calendar.current.component(.hour, from: selectedTime),
                                                            minute: Calendar.current.component(.minute, from: selectedTime),
                                                            second: 0,
                                                            of: adjustedDate) {
                    
                    adjustedDate = adjustedTime
                    
                }
            }
            
            if enjectedRecursiveValue == .weekly {
                
                let todayWeekDay = Calendar.current.component(.weekday, from: Date())
                
                let selectedWeekDay = Calendar.current.component(.weekday, from: selectedDate)
                
                if selectedWeekDay != todayWeekDay {
                    
                    let daysToAdjust = (selectedWeekDay - todayWeekDay + 7) % 7
                    
                    adjustedDate = Calendar.current.date(byAdding: .day, value: daysToAdjust, to: Date()) ?? Date()
                    
                    
                }
                
                if let adjustedTime = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: selectedTime),
                   minute: Calendar.current.component(.minute, from: selectedTime),
                   second: 0,
                   of: adjustedDate) {
                       
                       adjustedDate = adjustedTime
                       
                   }
            }
            
            if let combinedDate = choreStore.combine_Date(date: adjustedDate, time: selectedTime) {
                
                
                var title: String = ""
                
                var body: String = ""
                
                switch(enjectedRecursiveValue) {
                    
                case .none:
                    title = "Chore Reminder"
                    body = "\(enjectedChore) at \(choreStore.toString_Time(date: selectedTime))"
                    
                case .daily:
                    title = "Daily Chore"
                    body = "\(enjectedChore). Reminding you like you asked, every day at \(choreStore.toString_Time(date: selectedTime))"
                    
                case .weekly:
                    title = "Weekly Chore"
                    body = "\(enjectedChore). Reminding you like you asked, every \(choreStore.getWeekDayFor(date: selectedDate)) at \(choreStore.toString_Time(date: selectedTime))"
                    
                case .monthly:
                    title = "Monthly Chore"
                    body = "\(enjectedChore). Reminding you like you asked, every month on the \(choreStore.getMonthSuffix(date: selectedDate)) at \(choreStore.toString_Time(date: selectedTime))"
                    
                }
                
                choreStore.removeFromChoreList(chore: oldChore, due: oldDate, at: oldTime, recurring: oldRecursiveValue)
                
                let notificationIds = notificationManager.scheduleNotification(title: title, body: body, eventDate: combinedDate, recurring: enjectedRecursiveValue)
                
                choreStore.addToChoreList(chore: enjectedChore, due: adjustedDate, at: selectedTime, recurring: enjectedRecursiveValue, notificationIds: notificationIds)
                
            }
        }
        
    
        enjectedChore = ""
        isChoreExisting = hasChore
        
        showEditAlert = true
        
        }
    
    
}

struct EditChoreView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        EditChoreView()
            .environmentObject(ChoreStore())
    }
}

