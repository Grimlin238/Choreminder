/*
 SettingsView.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    @AppStorage("userReminderHour") private var reminderHour: Int = 9
    @AppStorage("userSendMonthly") private var monthlyUpcoming: Bool = false
    
    private var reminderHourView: some View {
        
        VStack {
            
            Text("Remind me everyday at \(reminderHour):00A.M. of chores I have upcoming foer the day.")
                .font(.title2)
                .padding()
            
            Stepper("Hour", value: $reminderHour, in: 5...11)
                .padding()
                .padding()
            
            Text("Note: Do to iOS system limitations, Chore might remind you later than expected.")
                .font(.subheadline)
            Spacer()
                
        }
        .padding()
        
    }
    
    private var sendMonthlyView: some View {
        
        VStack {
            
            Toggle("Remind me at the beginning of every month of upcoming chores for that month.", isOn: $monthlyUpcoming)
            Spacer()
            
        }
        .padding()
        
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            reminderHourView
                .padding(.horizontal, 16)
            
            sendMonthlyView
                .padding(.horizontal, 16)
            
            Spacer()
            Text("App Version: 1.0")
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Settings")
        
    }
}

struct SettingsView_Preview: PreviewProvider {
    
    static var previews: some View {
        
        SettingsView()
            .environmentObject(ChoreStore())
        
    }
}
