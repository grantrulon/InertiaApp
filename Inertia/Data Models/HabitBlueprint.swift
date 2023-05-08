//
//  HabitBlueprint.swift
//  Inertia
//
//  Created by Grant Rulon on 4/11/23.
//

import Foundation
import SwiftUI


class HabitBlueprint: Identifiable {
    var id: UUID = UUID()
    var key: String
    
    var name: String
    var description: String
    var recurringDays: [Days] = []
    var color: Color = .gray
    var importance: Int
    
    init(name: String, description: String, days: [Days], color: Color, importance: Int, key: String) {
        self.name = name
        self.description = description
        self.recurringDays = days
        self.color = color
        self.importance = importance
        self.key = key
    }
}

