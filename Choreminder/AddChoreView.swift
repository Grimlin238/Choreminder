/*
 AddChoreView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */

import SwiftUI

struct AddChoreView: View {
    @EnvironmentObject var choreStore: ChoreStore
    @State private var selectedDate = Date()
    @State private var selectedTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var userInput: String = ""
    @State private var showSuccessConformation = false
    
    @State private var recurrsive: Repeating = .none
    
    @State private var isChoreExisting = false
    
    @FocusState private var isFocused: Bool
    
    @AccessibilityFocusState private var focus: Bool
    
    @State private var selectedWeekday: Weekday = Weekday.orderWeekDays.first ?? .sunday
    
    @State private var selectedDateOfMonth: Int = 1
    
    private var textFieldView: some View {
        
        VStack {

            Spacer()
            
            TextField("Enter Chore", text: $userInput)
                
                .background(Color.indigo.opacity(0.5))
            
                .foregroundColor(.white)
                .border(Color.white, width: 2)
            
                .accessibilityFocused($focus)
            
                .focused($isFocused)
                .toolbar {
                    
                    ToolbarItemGroup(placement: .keyboard) {
                        
                        Spacer()
                        
                        Button("Done") {
                            
                            isFocused = false
                            
                        }
                        .accessibilityHint("Double tap to dismiss the keyboard")
                    }
                }
            
            Spacer()
            
        }
        
        .cornerRadius(10)
        
    }
    
    private var dateSelectionView: some View {
        
        VStack {
            
            DatePicker("Select a date",
                       selection: $selectedDate,
                       in: Date()...,
                       displayedComponents: .date)
            .datePickerStyle(.compact)
            .background(Color.indigo)
            .foregroundColor(.white)
            .fontWeight(.bold)
            Spacer()
            
        }
        
        .cornerRadius(10)
    
    }
    
    private var timeSelectionView: some View {
        
        VStack {
            
            DatePicker("Choose a time",
                       selection: $selectedTime,
                       displayedComponents: .hourAndMinute)
            .datePickerStyle(.compact)
            .background(Color.indigo)
            .foregroundColor(.white)
            .fontWeight(.bold)
            Spacer()
            
        }
        .cornerRadius(10)
    }
    
    private var recurssionView: some View {
        
        VStack {
            
            Text("Frequency?")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibility(addTraits: .isHeader)
            
            Picker("Frequency?", selection:  $recurrsive) {
                    
                    ForEach(Repeating.allCases, id: \.self) { recurrance in
                        
                        Text(recurrance.rawValue)
                            .foregroundColor(.white)
                            .accessibilityHint("Double tap to select")
                        
                    }
                }
                
                .pickerStyle(.menu)
                .background(Color.white)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityHint("Double tap to open menu.")
            Spacer()
        }
        .cornerRadius(10)
    }
    
    private var weekdaySelectionView: some View {
        
        VStack {
            
            Text("Select a Weekday")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibility(addTraits: .isHeader)
            
            Picker("Select a Weekday", selection: $selectedWeekday) {
                
                ForEach(Weekday.orderWeekDays, id: \.self) { day in
                    
                    Text(day.weekdayName)
                        .foregroundColor(.white)
                        .accessibilityHint("Double tap to select")
                    
                }
            }
            
            .pickerStyle(.menu)
            .foregroundColor(.black)
            .background(Color.white)
            .accessibilityHint("Double tap to open menu.")
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .cornerRadius(10)
    }
    
    private var monthDateSelectionView: some View {
        
        VStack {
            
            Text("Select a DEate")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibility(addTraits: .isHeader)
            
            Picker("Select a Date", selection: $selectedDateOfMonth) {
                
                ForEach(1...31, id: \.self) { day in
                    Text("\(day)")
                        .foregroundColor(.white)
                        .accessibilityHint("Double tap to select.")
                    
                }
            }
            
            .pickerStyle(.menu)
            .background(Color.white)
            .foregroundColor(.black)
            .accessibilityHint("Double tap to open menu.")
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        
        .cornerRadius(10)
        
    }
    
    private var dynamicView: some View {
        ZStack {
            
            Color.indigo
                .ignoresSafeArea()
            
            if recurrsive == .none {
                
                VStack {
                    
                    dateSelectionView
                        .padding(.horizontal, 16)
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                    
                }
            } else if recurrsive == .daily {
                
                VStack {
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                    
                }
            } else if recurrsive == .weekly {
                
                VStack {
                    
                    weekdaySelectionView
                        .padding(.horizontal, 16)
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                }
            } else if recurrsive == .monthly {
                
                VStack {
                    
                    monthDateSelectionView
                        .padding(.horizontal, 16)
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                }
            }
            
        }
    }
    
    private var addButtonView: some View {
        HStack {
            
            Button("Add to My Chores") {
                
                saveChore()
                    
            }
            
            .disabled(userInput.isEmpty || userInput == " " || DateManager.isTooCurrent(date: selectedDate, time: selectedTime, recurrance: recurrsive))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            .accessibilityHint("Double tap to add to chore list.")
            
            .alert(isPresented: $showSuccessConformation) {
                
                if isChoreExisting {
                    
                    return Alert(
                        
                    title: Text("Chore already exists"),
                        
                    message: Text("That chore already exists."),
                        
                        dismissButton: .default(Text("OK"))
                        
                    )
                } else {
                    return Alert(
                        
                        title: Text("Success :-)"),
                        
                        message: Text("Chore added successfully to My Chores."),
                        
                        dismissButton: .default(Text("Ok! Got it!"))
                        )
                }
                
            }
        
        }
        
        .padding(.horizontal)
        
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("New Chore")
                .font(.title)
                .fontWeight(.bold)
                .accessibilityAddTraits(.isHeader)
            
            Spacer()
            
            textFieldView
                .padding(.horizontal, 16)
            
            recurssionView
                .padding(.horizontal, 16)
            
            dynamicView
                .padding(.horizontal, 16)
            
            Spacer()
            addButtonView
                .padding(.bottom, 16)
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        
        .onAppear {
            focus = true
        }
    }

    private func saveChore() {
        
        
        let hasChore = choreStore.isChoreExist(chore: userInput, due: selectedDate, at: selectedTime, weekday: selectedWeekday, date: selectedDateOfMonth, recurring: recurrsive)
        
        if !hasChore {
              
            if let combinedDate = DateManager.combine_Date(date: selectedDate, time: selectedTime) {
                
                var title = NotificationManager.getNotificationTitle(for: recurrsive)
                
                var body = NotificationManager.getNotificationBody(for: userInput, at: DateManager.toString_Time(date: selectedTime), on: selectedDateOfMonth, on: selectedWeekday, for: recurrsive)
                let notificationIds = NotificationManager.scheduleNotification(title: title, body: body, eventDate: combinedDate, weekday: selectedWeekday, day: selectedDateOfMonth, recurring: recurrsive)
                
                choreStore.addToChoreList(chore: userInput, due: selectedDate, at: selectedTime, weekday: selectedWeekday, date: selectedDateOfMonth, recurring: recurrsive, notificationIds: notificationIds)
                
                let reminderHour = UserDefaults.standard.integer(forKey: "userReminderHour")
                
                let sendMonthly = UserDefaults.standard.bool(forKey: "userSendMonthly")
                
                NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendMonthly)
                
            }
        }
        
        userInput = ""
        isChoreExisting = hasChore
        showSuccessConformation = true
        isFocused = false
        selectedDate = Date()
        selectedTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
        recurrsive = .none
        selectedDateOfMonth = 1
        selectedWeekday = .sunday
    }
}

struct AddChoreView_preview: PreviewProvider {
    
    static var previews: some View {
        
    AddChoreView()
            .environmentObject(ChoreStore())
    }
}

