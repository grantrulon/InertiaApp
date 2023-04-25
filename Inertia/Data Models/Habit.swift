//
//  Habit.swift
//  Inertia
//
//  Created by Grant Rulon on 4/12/23.
//

import Foundation
import SwiftUI


struct Habit: Identifiable {
    var id = UUID()
    var name: String
    var description: String
    var date: Date
    var importance: Int
    var color: Color
    var mode: HabitMode
    var totalPoints: Int = 100
    var completionPoints: Int = 0
    var isComplete: Bool = false
    
    init(name: String, description: String, date: Date, importance: Int, mode: HabitMode, color: Color) {
        self.name = name
        self.description = description
        self.date = date
        self.importance = importance
        self.mode = mode
        self.color = color
    }
    
//    func setCompletionPoints(_ completionPoints: Int) {
//        self.completionPoints = completionPoints
//    }
}



// Possibly add an icon down the road
