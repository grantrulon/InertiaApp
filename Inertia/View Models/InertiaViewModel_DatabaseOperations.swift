//
//  InertiaViewModel_DatabaseOperations.swift
//  Inertia
//
//  Created by Grant Rulon on 5/8/23.
//

import Foundation
import FirebaseFirestore
import SwiftUI

extension InertiaViewModel {
    
    
    
    // From DeleteButton
    
    // Delete a blueprint and other connected data
    func deleteBlueprint(name: String, key: String) {
        
        // STOP edit mode
        editMode = false
        
        // Find index of the blueprint and delete it from state
        let blueprintIndex = blueprints.firstIndex {
            $0.name == name
        }
        if let blueprintIndex {
            blueprints.remove(at: blueprintIndex)
        } else {
            print("did not find the blueprint you want to delete")
        }
        
        // Find index of the possible corresponding habit and delete from state
        //  Also find the key for the database delete
        var habitKey: String = ""
        let habitIndex = todayHabits.firstIndex {
            $0.name == name
        }
        if let habitIndex {
            habitKey = todayHabits[habitIndex].key
            todayHabits.remove(at: habitIndex)
        } else {
            print("There are no habits with this name to delete")
        }
        
        // Update stats
        let today = dateToString(Date.now)
        habits[today] = todayHabits
        updateStats()
        
        // Delete blueprint from the database
        let db = Firestore.firestore()
        
        db.collection("Blueprints").document(key).delete() { error in
            if let error {
                print("Error deleting Blueprint \(error)")
            } else {
                print("Successfully deleted Blueprint document \(key)")
            }
        }
        
        // Delete the habit from the database if there is one
        if habitKey == "" {
            print("There are no habits today that correspond to the deleted blueprint")
            return
        }
        
        db.collection("Habits").document(habitKey).delete() { error in
            if let error {
                print("Error deleting Habit \(error)")
            } else {
                print("Successfully deleted Habit document \(key)")
            }
        }
    }
    
    
    
    
    // From NewBlueprintView
    
    func addBlueprint(name: String, description: String, importance: Int, color: Color, monday: Bool, tuesday: Bool, wednesday: Bool, thursday: Bool, friday: Bool, saturday: Bool, sunday: Bool) {
        
        var newData: [String:Any] = [:]
        newData["name"] = name
        newData["description"] = description
        newData["importance"] = importance
        let colorValues = NSColor(color).cgColor.components ?? [0, 0, 0, 0]
        newData["red"] = Double(colorValues[0]) * 100
        newData["green"] = Double(colorValues[1]) * 100
        newData["blue"] = Double(colorValues[2]) * 100
        newData["uid"] = user.uid
        newData["email"] = user.email
        
        newData["monday"] = monday
        newData["tuesday"] = tuesday
        newData["wednesday"] = wednesday
        newData["thursday"] = thursday
        newData["friday"] = friday
        newData["saturday"] = saturday
        newData["sunday"] = sunday
        
        var blueprintDays: [Days] = []
        if monday {blueprintDays.append(.monday)}
        if tuesday {blueprintDays.append(.tuesday)}
        if wednesday {blueprintDays.append(.wednesday)}
        if thursday {blueprintDays.append(.thursday)}
        if friday {blueprintDays.append(.friday)}
        if saturday {blueprintDays.append(.saturday)}
        if sunday {blueprintDays.append(.sunday)}
        
        
        let db = Firestore.firestore()
        let key = UUID().uuidString
        let document = db.collection("Blueprints").document(key)
        
        document.setData(newData) { error in
            if let error {
                print("Error creating new blueprint \(error)")
            } else {
                print("Successfully added a blueprint")
                self.blueprints.append(HabitBlueprint(name: name, description: description, days: blueprintDays, color: color, importance: importance, key: key))
            }
        }
        
        
        var todayWeekday = Calendar.current.component(.weekday, from: Date.now)
        var shouldAddHabit = false
        
        switch todayWeekday {
        case 1:
            if sunday == true {
                shouldAddHabit = true
            }
        case 2:
            if monday == true {
                shouldAddHabit = true
            }
        case 3:
            if tuesday == true {
                shouldAddHabit = true
            }
        case 4:
            if wednesday == true {
                shouldAddHabit = true
            }
        case 5:
            if thursday == true {
                shouldAddHabit = true
            }
        case 6:
            if friday == true {
                shouldAddHabit = true
            }
        case 7:
            if saturday == true {
                shouldAddHabit = true
            }
        default:
            shouldAddHabit = false
        }
        
        
        if shouldAddHabit {
            
            let newHabit = Habit(key: UUID().uuidString, name: name, date: Date.now, importance: importance, color: color, isComplete: false)
            todayHabits.append(newHabit)
            
            // Update stats
            let today = dateToString(Date.now)
            habits[today] = todayHabits
            updateStats()
            
            var newData: [String:Any] = [:]
            newData["name"] = newHabit.name
            newData["importance"] = newHabit.importance
            newData["isComplete"] = newHabit.isComplete
            newData["uid"] = user.uid
            newData["date"] = dateToString(newHabit.date)
            
            let colorValues = NSColor(newHabit.color).cgColor.components ?? [0, 0, 0, 0]
            newData["red"] = Double(colorValues[0]) * 100
            newData["green"] = Double(colorValues[1]) * 100
            newData["blue"] = Double(colorValues[2]) * 100
            
            let db = Firestore.firestore()
            let habitsCollection = db.collection("Habits")
            let document = habitsCollection.document(newHabit.key)
            
            document.setData(newData) { error in
                if let error {
                    print("Error creating new habit \(error)")
                } else {
                    print("Successfully added a habit \(newHabit.name)")
                }
            }
        }
    }
}
