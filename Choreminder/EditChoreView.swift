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
    @State private var enjectedWeekday: Weekday = .sunday
    @State private var enjectedMonthDate: Int = 1
    @State var enjectedRecursiveValue: Repeating = .none
    @State private var showDeleteAlert = false
    
    @State private var showEditAlert = false
    
    @State private var oldChore = ""
    
    @State private var oldDate = Date()
    
    @State private var oldTime = Date()
    
    @State private var oldWeekday: Weekday = .sunday
    
    @State private var oldRecursiveValue: Repeating = .none
    
    @State private var oldDateOfMonth: Int = 1
    
    
    @State private var isChoreExisting = false
    
    @FocusState private var isFocused: Bool
    
    @AccessibilityFocusState private var focus: Bool
    
    init(enjectedChore: String = "Default", enjectedDate: Date = Date(), enjectedTime: Date = Date(), enjectedWeekday: Weekday = .sunday, enjectedMonthDate: Int = 1, enjectedRecursiveValue: Repeating = .none) {
        
        _enjectedChore = State(initialValue: enjectedChore)
        _selectedDate = State(initialValue: enjectedDate)
        _selectedTime = State(initialValue: enjectedTime)
        _enjectedWeekday = State(initialValue: enjectedWeekday)
        _enjectedMonthDate = State(initialValue: enjectedMonthDate)
        _enjectedRecursiveValue = State(initialValue: enjectedRecursiveValue)
    }
    
    private var textFieldView: some View {
        
        VStack {
            
            Spacer()
            
            TextField("Enter Updated Chore", text: $enjectedChore)
            
                .background(Color.indigo.opacity(0.5))
                .foregroundColor(.white)
                .border(Color.white, width: 0.2)
            
                .accessibilityFocused($focus)
    
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
            
            Text("Updated Frequency?")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibility(addTraits: .isHeader)
        
            Picker("Updated Frequency?", selection:  $enjectedRecursiveValue) {
                
                ForEach(Repeating.allCases, id: \.self) { recurrance in
                    
                    Text(recurrance.rawValue)
                        .foregroundColor(.white)
                        .accessibilityHint("Double tap to select.")
                }
            }
            
            .pickerStyle(.menu)
            .background(Color.white)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityHint("Double tap to open menu")
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
            
            Picker("Select a Weekday", selection: $enjectedWeekday) {
                
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
            
            Picker("Select a Date", selection: $enjectedMonthDate) {
                
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
            
            if enjectedRecursiveValue == .none {
                
                VStack {
                    
                    dateSelectionView
                        .padding(.horizontal, 16)
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                    
                }
            } else if enjectedRecursiveValue == .daily {
                
                VStack {
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                    
                }
            } else if enjectedRecursiveValue == .weekly {
                
                VStack {
                    
                    weekdaySelectionView
                        .padding(.horizontal, 16)
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                }
            } else if enjectedRecursiveValue == .monthly {
                
                VStack {
                    
                    monthDateSelectionView
                        .padding(.horizontal, 16)
                    
                    timeSelectionView
                        .padding(.horizontal, 16)
                }
            }
            
        }
    }
    
    private var deleteAndEditButtonView: some View {
        
        HStack(spacing: 16) {
            
            Button("Save Edit") {
                
                updateChore()
                
            }
            .disabled(enjectedChore.isEmpty || enjectedChore == " " || choreStore.isTooCurrent(date: selectedDate, time: selectedTime, recurrance: enjectedRecursiveValue))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            .accessibilityHint("Double tap to save edit.")
            
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
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .padding()
            .accessibilityHint("Double tap to delete this chore.")
            
            .alert("Are you sure?", isPresented: $showDeleteAlert) {
                
                Button("Cancel", role: .cancel) { }
                
                Button("Yes, I'm Sure.", role: .destructive) {
                    
                    choreStore.removeFromChoreList(chore: oldChore, due: oldDate, at: oldTime, weekday: oldWeekday, date: oldDateOfMonth, recurring: oldRecursiveValue)
                    
                    dismiss()
                    
                }
                
            }
                
                message: {
                    
                    Text("Deleting this chore will remove it from your chore list. This action can't be undone.")
                    
                }
            
        }
        .padding(.horizontal)
    }
 
    var body: some View {
        
        VStack(spacing: 16) {
            
            textFieldView
                .padding(.horizontal, 16)
            
            recurssionView
                .padding(.horizontal, 16)
            
            dynamicView
                .padding(.horizontal, 16)
            
Spacer()
            deleteAndEditButtonView
                .padding(.bottom, 16)
            
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Edit Chore")
        
        .onAppear {
            
            focus = true
            
            oldChore = enjectedChore
            
            oldDate = selectedDate
            
            oldTime = selectedTime
            
            oldWeekday = enjectedWeekday
            
            oldDateOfMonth = enjectedMonthDate
            
            oldRecursiveValue = enjectedRecursiveValue
            
        }
        
    }
    
    private func updateChore() {
        
        let hasChore = choreStore.isChoreExist(chore: enjectedChore, due: selectedDate, at: selectedTime, weekday: oldWeekday, date: enjectedMonthDate, recurring: enjectedRecursiveValue)
        
        if !hasChore {
            
            if let combinedDate = choreStore.combine_Date(date: selectedDate, time: selectedTime) {
                
                
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
                
                choreStore.removeFromChoreList(chore: oldChore, due: oldDate, at: oldTime, weekday: oldWeekday, date: oldDateOfMonth, recurring: oldRecursiveValue)
                
                let notificationIds = notificationManager.scheduleNotification(title: title, body: body, eventDate: combinedDate, weekday: enjectedWeekday, day: enjectedMonthDate, recurring: enjectedRecursiveValue)
                
                choreStore.addToChoreList(chore: enjectedChore, due: selectedDate, at: selectedTime, weekday: enjectedWeekday, date: enjectedMonthDate, recurring: enjectedRecursiveValue, notificationIds: notificationIds)
                
            }
        }
        
    
        enjectedChore = ""
        isChoreExisting = hasChore
        
        showEditAlert = true
        isFocused = false
        }
    
    
}

struct EditChoreView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        EditChoreView()
            .environmentObject(ChoreStore())
    }
}

