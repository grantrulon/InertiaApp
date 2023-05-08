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
    var key: String
    var name: String
    var date: Date
    var importance: Int
    var color: Color
    var isComplete: Bool = false
    
    init(key: String, name: String, date: Date, importance: Int, color: Color, isComplete: Bool) {
        self.key = key
        self.name = name
        self.date = date
        self.importance = importance
        self.color = color
        self.isComplete = isComplete
    }
    
    func encodeToStorage() -> [String:Any] {
        let colorValues = NSColor(self.color).cgColor.components ?? [0, 0, 0, 0]
        
        var data: [String:Any] = [
            "name" : self.name,
            "date" : self.date.formatted(.dateTime
                    .day().month().year()
                ),
            "isComplete" : self.isComplete,
            "importance" : self.importance,
            "red" : Double(colorValues[0]) * 100,
            "green" : Double(colorValues[1]) * 100,
            "blue" : Double(colorValues[2]) * 100,
        ]
        
        return data
    }
    
//    func setCompletionPoints(_ completionPoints: Int) {
//        self.completionPoints = completionPoints
//    }
}


