/*
 SettingsView.swift
 Part of Chore
 Copyright 2024 Majestee M Daniels
 All rights reserved.
 */
 
import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    @AppStorage("userReminderHour") private var reminderHour: Int = 9
    @AppStorage("userSendMonthly") private var sendEveryMonth: Bool = false
    @AppStorage("checkIn") private var toggleCheckIn: Bool = false
    
    @AccessibilityFocusState private var focus: Bool
    
    private var reminderHourView: some View {
        
        VStack {
            
            Toggle("Schedule daily check-in?", isOn: $toggleCheckIn)
                .font(.title2)
                .padding()
            Spacer()
                
            if toggleCheckIn {
                
                Text("Remind me at )\(reminderHour):00A.M. when I have chores do today")
                    .font(.subheadline)
                    .padding()
                
                Stepper("Hour", value: $reminderHour, in: 5...11)
                    .padding()
                    .font(.subheadline)
                Spacer()
            }
            }
                .onChange(of: reminderHour) { hour, _ in
                    
                    NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: sendEveryMonth)
                    
                }
        
                .onChange(of: toggleCheckIn) { value, _ in
                    
                    NotificationManager.cancelCheckins(checkin: "Daily Check-in")
                    
                    }
        .padding()
        
    }
    
    private var sendMonthlyView: some View {
        
        VStack {
            
            Toggle("Remind me to check for upcoming chores for the month at the beginning of the month", isOn: $sendEveryMonth)
                .padding()
                .font(.title2)
            Spacer()
            
        }
                 
                .onChange(of: sendEveryMonth) { isOn, _ in
                    
                    NotificationManager.scheduleCheckin(time: reminderHour, sendMonthly: isOn)
                    
                }
                 
        .padding()
        
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            reminderHourView
                .padding(.horizontal, 16)
                .accessibilityFocused($focus)
            
            sendMonthlyView
                .padding(.horizontal, 16)
            
            Spacer()
            Text("App Version: 1.0")
                .padding(.bottom, 16)
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Settings")
        
        .onAppear {
            
            focus = true
            
        }
        
    }
}

struct SettingsView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        SettingsView()
            .environmentObject(ChoreStore())
        
    }
}
