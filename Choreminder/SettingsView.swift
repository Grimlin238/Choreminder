//
//  SettingsView.swift
//  Choreminder
//
//  Created by Tee Lashley on 1/2/25.
//


import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var choreStore: ChoreStore
    @AppStorage("userReminderHour") private var reminderHour: Int = 9
    @AppStorage("userSendMonthly") private var monthlyUpcoming: Bool = false
    
    private var reminderHourView: some View {
        
        VStack {
            
            Text("Remind me everyday at \(reminderHour):00A.M. of chores I have upcoming.")
            
            Stepper("Hour", value: $reminderHour, in: 5...11)
            
        }
        
    }
    
    private var sendMonthlyView: some View {
        
        VStack {
            
            Toggle("Remind me at the beginning of every month of upcoming chores for that month.", isOn: $monthlyUpcoming)
            
        }
        
    }
    
    var body: some View {
        
        VStack {
            Spacer()
            reminderHourView
            sendMonthlyView
            
        }
        .background(Color.indigo)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
