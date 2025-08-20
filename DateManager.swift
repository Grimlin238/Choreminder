/*
 DateManager.swift
 Part of Chore
 copyright 2024 Tyian R. Lashley
 All rights reserved
 */

import Foundation

class DateManager {
        
   static func combine_Date(date: Date, time: Date) -> Date? {
       
       let calendar = Calendar.current
       let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
       
       let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
       
       var combinedComponents = DateComponents()
       
       combinedComponents.year = dateComponents.year
       
       combinedComponents.month = dateComponents.month
       combinedComponents.day = dateComponents.day
       
       combinedComponents.hour = timeComponents.hour
       
       combinedComponents.minute = timeComponents.minute
       
       combinedComponents.second = timeComponents.second
       
       return calendar.date(from: combinedComponents)
       
   }
   
   static func toString_Date(date: Date) -> String {
       
       let formattedDate = DateFormatter()
       
       formattedDate.dateStyle = .medium
       
       formattedDate.timeStyle = .none
       
       return formattedDate.string(from: date)
       
   }
   
   static func toString_Time(date: Date) -> String {
       
       let formattedTime = DateFormatter()
       
       formattedTime.dateStyle = .none
       
       formattedTime.timeStyle = .short
       
       return formattedTime.string(from: date)
       
   }
   
   static func isToday(day: Date) -> Bool {
       
       let calendar = Calendar.current
       
       return calendar.isDateInToday(day)
       
   }
   
   static func isBeginningOfMonth() -> Bool {
       
       let date = Date()
       
       let calendar = Calendar.current
       
       let isDayOne = calendar.component(.day, from: date)
       
       return isDayOne == 1
       
   }
       
   static func getCurrentMonth() -> String {
       
       let date = Date()
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "MMM"
       
       let currentMonth = dateFormatter.string(from: date)
       
       return currentMonth
       
   }
   
   static func getMonthForStoredChore(date: Date) -> String {
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "MMM"
       
       let month = dateFormatter.string(from: date)
       
       return month
       
   }
   
   static func getWeekDayFor(date: Date) -> String {
       
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "MMM dd, yyyy"
       
       var weekDayName: String = ""
       
       let calendar = Calendar.current
       let weekNumber = calendar.component(.weekday, from: date)
       
       weekDayName = dateFormatter.weekdaySymbols[weekNumber - 1]
       
       return weekDayName
       
   }
   
    static func getMonthSuffix(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        var dateWithSuffix: String = ""
        
        let calendar = Calendar.current
        
        let dayOfMonth = calendar.component(.day, from: date)
        
        let suffix: String
        
        switch(dayOfMonth) {
            
        case 1, 21, 31:
            suffix = "st"
            
        case 2, 22:
            suffix = "nd"
            
        case 3, 23:
            suffix = "rd"
            
        default:
            suffix = "th"
            
        }
        
        dateWithSuffix = "\(dayOfMonth)\(suffix)"
        
        return dateWithSuffix
        
    }
    
   static func isTooCurrent(date: Date, time: Date, recurrance: Repeating) -> Bool {
       let calendar = Calendar.current
       
       guard let combinedDate = combine_Date(date: date, time: time) else {
           return false
       }
       
       let now = calendar.date(
           from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
       )!
       
       let truncatedCombinedDate = calendar.date(
           from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: combinedDate)
       )!
       
       if recurrance == .none {
           
           return truncatedCombinedDate <= now
       }
       
       return false
   }
   
}
