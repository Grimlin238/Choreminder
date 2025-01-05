//
//  AddChoreView.swift
//  Choreminder
//
//  Created by Tee Lashley on 1/2/25.
//


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
    
    private var textFieldView: some View {
        
        VStack {
            
            TextField("Enter Chore", text: $userInput)
            
        }
    }
    
    private var dateSelectionView: some View {
        
        VStack {
            
            DatePicker("Select a date",
                       selection: $selectedDate,
                       in: Date()...,
                       displayedComponents: .date)
            
        }
    }
    
    private var timeSelectionView: some View {
        
        VStack {
            
            DatePicker("Choose a time",
                       selection: $selectedTime,
                       displayedComponents: .hourAndMinute)
            
        }
        
    }
    
    private var recurssionView: some View {
        
        VStack {
            
            Text("Recurring?")
                .accessibilityAddTraits(.isHeader)
            Picker("Repeating?", selection:  $recurrsive) {
                
                ForEach(Repeating.allCases, id: \.self) { recurrance in
                    
                    Text(recurrance.rawValue)
                    
                }
            }
            
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var addButtonView: some View {
        HStack {
            
            Button("Add to Chores") {
                
                saveChore()
                    
            }
            
            .disabled(userInput.isEmpty || userInput == " " || choreStore.isTooCurrent(date: selectedDate, time: selectedTime, recurrance: recurrsive))
            
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
        
    }
    
    var body: some View {
         
            VStack {
                Text("Create a Chore")
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityAddTraits(.isHeader)
                    Spacer()
                
                
                textFieldView
                
                dateSelectionView
                
                timeSelectionView
                
                recurssionView
                
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
