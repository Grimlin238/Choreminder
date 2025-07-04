/*
 Weekday.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */

import Foundation

enum Weekday: Int, CaseIterable, Codable {
    
case sunday = 1
case monday = 2
case tuesday = 3
case wednesday = 4
case thursday = 5
case friday = 6
case saturday = 7

    var weekdayName: String {
        
        switch (self) {
            
        case .sunday:
            return "Sunday"
            
        case .monday:
            return "Monday"
            
        case .tuesday:
            return "Tuesday"
            
        case .wednesday:
            return "Wednesday"
            
        case .thursday:
            return "Thursday"
            
        case .friday:
            return "Friday"
            
        case .saturday:
            return "Saturday"
            
        }
    }
    
    static var orderWeekDays: [Weekday] {
        
        let calendar = Calendar.current
        
        let firstDayOfWeek = calendar.firstWeekday
        
        switch(firstDayOfWeek) {
            
        case 1:
            return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
            
        case 2:
            return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
            
        default:
            return [.sunday, .monday, .tuesday, .wednesday, thursday, .friday, .saturday]
            
        }
        
        
    }
}
