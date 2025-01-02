//
//  Chore.swift
//  Choreminder
//
//  Created by Tee Lashley on 1/2/25.
//

import Foundation

struct Chore: Identifiable, Equatable, Codable {
    let id: UUID
    let chore: String
    let due: Date
    let at: Date
    let recurring: Repeating
    var notificationIds: [String]
    
    init(chore: String, due: Date, at: Date, recurring: Repeating, notificationIds: [String]) {
        id = UUID()
        self.chore = chore
        self.due = due
        self.at = at
        self.recurring = recurring
        self.notificationIds = notificationIds
    }
    
    static func == (lhs: Chore, rhs: Chore) -> Bool {
        
        return lhs.chore == rhs.chore && lhs.due == rhs.due && lhs.at == rhs.at
        
    }
}

