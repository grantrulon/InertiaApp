//
//  HabitBlueprint.swift
//  Inertia
//
//  Created by Grant Rulon on 4/11/23.
//

import Foundation
import SwiftUI
import HexGrid




class HabitBlueprint: Identifiable, OffsetCoordinateProviding {
    var id: Int { offsetCoordinate.hashValue }
    var offsetCoordinate: OffsetCoordinate
    var key: String
    
    var name: String
    var description: String
    var recurringDays: Set<Days> = Set<Days>()
    var specificDates: Set<Date> = Set<Date>()
    var color: Color = .gray
    var importance: Int
    
    var mode: HabitMode
    
    
    init(name: String, description: String, color: Color, importance: Int, mode: HabitMode, offsetCoordinate: OffsetCoordinate, key: String) {
        self.name = name
        self.description = description
        self.color = color
        self.importance = importance
        self.mode = mode
        self.offsetCoordinate = offsetCoordinate
        self.key = key
    }
}


// Maybe a habit blueprint where something translates each of the blueprints into actual day-of habit to fulfil and record for data

