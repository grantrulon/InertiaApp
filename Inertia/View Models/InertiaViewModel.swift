//
//  InertiaViewModel.swift
//  Inertia
//
//  Created by Grant Rulon on 4/17/23.
//

import Foundation
import FirebaseFirestore
import HexGrid
import SwiftUI


class InertiaViewModel: ObservableObject {
    @Published var user: User = User(name: "", email: "")
    
    @Published var isLoggedIn = false {
        didSet {
            if isLoggedIn {
                fetchData()
            } else {
                blueprints = []
                todayHabits = []
                habits = [:]
                stats = [:]
                user.name = ""
                user.email = ""
                user.uid = ""
                doneGettingHabits = false
                doneGettingBlueprints = false
            }
        }
    }
    
    @Published var editMode = false
    @Published var addMode = false
    
    @Published var stats: [String:Record] = [:]
    @Published var blueprints: [HabitBlueprint] = []
    @Published var habits: [String:[Habit]] = [:]
    @Published var todayHabits: [Habit] = []
    
    var doneGettingBlueprints: Bool = false {
        didSet {
            if doneGettingBlueprints == true && doneGettingHabits == true && self.todayHabits.count == 0 {
                self.translateNewDay()
            }
        }
    }
    var doneGettingHabits: Bool = false {
        didSet {
            if doneGettingBlueprints == true && doneGettingHabits == true && self.todayHabits.count == 0 {
                self.translateNewDay()
            }
            sortHabits()
        }
    }
    
    
    // Helper function for mapping weekday component of a date, which is an Int, to a Days enum value
    func mapIntToWeekday(_ intIn: Int) -> Days {
        switch intIn {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return .sunday
        }
    }
    
    // Helper function for getting the string translation
    func dateToString(_ dateIn: Date) -> String {
        return dateIn.formatted(
                        .dateTime
                            .day().month().year()
                        )
    }
    
    // Helper function for translating the stats data into Record structs
    func stringToRecord(data dataIn: String, date dateIn: Date?) -> Record {
        let numbers = dataIn.components(separatedBy: ",")
        return Record(date: dateIn, numberComplete: Int(numbers[0]) ?? 1, numberTotal: Int(numbers[1]) ?? 1)
    }
    
    
    // Helper function for reordering the recorded habits
    func sortHabits() {
        // Sorting by importance - lower is more important
        self.todayHabits.sort {
            $0.importance > $1.importance
        }
        
        self.todayHabits.sort {
            !($0.isComplete && !$1.isComplete)
        }
        
        // Updating the dictionary
        self.habits[dateToString(Date.now)] = self.todayHabits
    }
    
    

}
