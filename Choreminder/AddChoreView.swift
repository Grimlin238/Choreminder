/*
 AddChoreView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */

import SwiftUI

struct AddChoreView: View {
    @EnvironmentObject var choreStore: ChoreStore
    @EnvironmentObject var notificationManager: NotificationManager
    
    @State private var selectedDate = Date()
    @State private var selectedTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @State private var userInput: String = ""
    @State private var showSuccessConformation = false
    
    @State private var recurrsive: Repeating = .none
    
    @State private var isChoreExisting = false
    
    @FocusState private var isFocused: Bool
    
    private var textFieldView: some View {
        
        VStack {
            
            Spacer()
            
            TextField("Enter Chore", text: $userInput)
            
                .focused($isFocused)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .toolbar {
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        
                        Spacer()
                        
                        Button("Done") {
                            
                            isFocused = false
                            
                        }
                        .accessibilityHint("Double tap to dismiss the keyboard")
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
            .foregroundColor(.black)
            Spacer()
            
        }
        .cornerRadius(10)
        .padding()
        
    }
    
    private var recurssionView: some View {
        
        VStack {
            
            Picker("Repeating?", selection:  $recurrsive) {
                
                ForEach(Repeating.allCases, id: \.self) { recurrance in
                    
                    Text(recurrance.rawValue)
                        .accessibilityHint("Double tap to select")
                    
                }
            }
            
            .pickerStyle(.menu)
            .background(Color.white)
            .foregroundColor(.black)
            .accessibilityHint("Double tap to open menu.")
            Spacer()
        }
        .cornerRadius(10)
        .padding()
    }
    
    private var addButtonView: some View {
        HStack {
            
            Button("Add to Chores") {
                
                saveChore()
                    
            }
            
            .disabled(userInput.isEmpty || userInput == " " || choreStore.isTooCurrent(date: selectedDate, time: selectedTime, recurrance: recurrsive))
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            .accessibilityHint("Double tap to add to my chores.")
            
            .alert(isPresented: $showSuccessConformation) {
                
                if isChoreExisting {
                    
                    return Alert(
                        
                    title: Text("Chore already exists"),
                        
                    message: Text("That chore already exists."),
                        
                        dismissButton: .default(Text("OK"))
                        
                    )
                } else {
                    return Alert(
                        
                        title: Text("Success =>"),
                        
                        message: Text("Your chore has been successfully saved."),
                        
                        dismissButton: .default(Text("Ok! Got it!"))
                        )
                }
                
            }
        
        }
        
        .padding(.horizontal)
        
    }
    
    var body: some View {
         
        VStack(spacing: 16) {
                Text("Create a Chore")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                    Spacer()
                
                textFieldView
                .padding(.horizontal, 16)
                
                dateSelectionView
                .padding(.horizontal, 16)
                
                timeSelectionView
                .padding(.horizontal, 16)
                
                recurssionView
                .padding(.horizontal, 16)
        
                Spacer()
                addButtonView
                    
            }
            .background(Color.indigo)
            .foregroundColor(.white)
        
    }
    
    private func saveChore() {
        
        
        let hasChore = choreStore.isChoreExist(chore: userInput, due: selectedDate, at: selectedTime, recurring: recurrsive)
        
        if !hasChore {
              
            var adjustedDate = selectedDate
            
            if recurrsive == .daily {
                
                adjustedDate = Calendar.current.startOfDay(for: Date())
                
                if let adjustedTime = Calendar.current.date(bySettingHour:Calendar.current.component(.hour, from: selectedTime),
                                                            minute: Calendar.current.component(.minute, from: selectedTime),
                                                            second: 0,
                                                            of: adjustedDate) {
                    
                    adjustedDate = adjustedTime
                    
                }
            }
            
            if recurrsive == .weekly {
                
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
                
                switch(recurrsive) {
                    
                case .none:
                    title = "Chore Reminder"
                    body = "\(userInput) at \(choreStore.toString_Time(date: selectedTime))"
                    
                case .daily:
                    title = "Daily Chore"
                    body = "\(userInput). reminding you like you asked, every day at \(choreStore.toString_Time(date: selectedTime))"
                    
                case .weekly:
                    title = "Weekly Chore"
                    body = "\(userInput). Reminding you like you asked, every \(choreStore.getWeekDayFor(date: selectedDate)) at \(choreStore.toString_Time(date: selectedTime))"
                    
                case .monthly:
                    title = "Monthly Chore"
                    body = "\(userInput). Reminding you like you asked, every month on the \(choreStore.getMonthSuffix(date: selectedDate)) at \(choreStore.toString_Time(date: selectedTime))"
                    
                }
                
                let notificationIds = notificationManager.scheduleNotification(title: title, body: body, eventDate: combinedDate, recurring: recurrsive)
                
                choreStore.addToChoreList(chore: userInput, due: adjustedDate, at: selectedTime, recurring: recurrsive, notificationIds: notificationIds)
                
            }
        }
        
        userInput = ""
        isChoreExisting = hasChore
        showSuccessConformation = true
        
    }
}

struct AddChoreView_preview: PreviewProvider {
    
    static var previews: some View {
        
    AddChoreView()
            .environmentObject(ChoreStore())
            .environmentObject(NotificationManager())
        
        
    }
}
