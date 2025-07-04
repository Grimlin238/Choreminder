/*
 Chore.swift
 Part of Chore
 Copyright 2024 Tyian R. Lashley.
 All rights reserved.
 */
 
import Foundation

struct Chore: Identifiable, Equatable, Codable {
    let id: UUID
    let chore: String
    let due: Date
    let at: Date
    let weekday: Weekday
    let date: Int
    let recurring: Repeating
    var notificationIds: [String]
    
    init(chore: String, due: Date, at: Date, weekday: Weekday, date: Int, recurring: Repeating, notificationIds: [String]) {
        id = UUID()
        self.chore = chore
        self.due = due
        self.at = at
        self.weekday = weekday
        self.date = date
        self.recurring = recurring
        self.notificationIds = notificationIds
    }
    
    static func == (lhs: Chore, rhs: Chore) -> Bool {
        
        return lhs.chore == rhs.chore && lhs.due == rhs.due && lhs.at == rhs.at
        
    }
}
