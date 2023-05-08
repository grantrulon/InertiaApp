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
    
    // From view model
    func fetchData() {
        // Create a database instance
        let db = Firestore.firestore()
        
        // Fetching the blueprint data
        db.collection("Blueprints").getDocuments() { (results, error) in
            if let error {
                print("Error getting blueprint data: \(error)")
            } else {
                
                // Loop through the documents and get the current user's blueprint information
                for document in results!.documents {
                    let data = document.data()
                    let uid = data["uid"] as? String ?? ""
                    if uid != self.user.uid {
                        continue
                    }
                    let name = data["name"] as? String ?? ""
                    let importance = data["importance"] as? Int ?? 1
                    let red = data["red"] as? Double ?? 0
                    let green = data["green"] as? Double ?? 0
                    let blue = data["blue"] as? Double ?? 0
                    let description = data["description"] as? String ?? ""
                    
                    // Days
                    let days = [data["monday"] as? Bool ?? false, data["tuesday"] as? Bool ?? false, data["wednesday"] as? Bool ?? false, data["thursday"] as? Bool ?? false, data["friday"] as? Bool ?? false, data["saturday"] as? Bool ?? false, data["sunday"] as? Bool ?? false]
                    var blueprintDays: [Days] = []
                    for (i, day) in Days.allCases.enumerated() {
                        if days[i] == true {
                            blueprintDays.append(day)
                        }
                    }
                    
                    if uid == self.user.uid {
                        self.blueprints.append(HabitBlueprint(name: name, description: description, days: blueprintDays, color: Color(red: red/100, green: green/100, blue: blue/100), importance: importance, key: document.documentID))
                    }
                }
                self.doneGettingBlueprints = true
            }
            
        }
        
        // Fetching Stats data
        db.collection("Stats").getDocuments() { (results, error) in
            if let error {
                print("Error getting stats documents \(error)")
            } else {
                for document in results!.documents {
                    if document.documentID != self.user.uid {
                        continue
                    }
                    
                    let data = document.data()
                    for date in data.keys {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM d, yyyy"
                        let statDate = dateFormatter.date(from: date)
                        
                        self.stats[date] = self.stringToRecord(data: data[date] as? String ?? "", date: statDate)
                    }
                    
                }
            }
        }
        
        // Fetching Habit data
        db.collection("Habits").getDocuments() { (results, error) in
            if let error {
                print("Error getting the habits documents \(error)")
            } else {
                
                for document in results!.documents {
                    let data = document.data()
                    let uid = data["uid"] as? String ?? ""
                    if uid != self.user.uid {
                        continue
                    }
                    
                    let red = data["red"] as? Double ?? 0
                    let green = data["green"] as? Double ?? 0
                    let blue = data["blue"] as? Double ?? 0
                    
                    let date = data["date"] as? String ?? ""
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, yyyy"
                    let habitDate = dateFormatter.date(from: date)
                    
                    let name = data["name"] as? String ?? ""
                    let importance = data["importance"] as? Int ?? 1
                    let isComplete = data["isComplete"] as? Bool ?? false
                    
                    if self.habits[date] == nil {
                        self.habits[date] = []
                    }
                    
                    self.habits[date]?.append(Habit(key: document.documentID, name: name, date: habitDate ?? Date.distantPast, importance: importance, color: Color(red: red/100, green: green/100, blue: blue/100), isComplete: isComplete))
                    
                    
                }
                
                self.todayHabits = self.habits[self.dateToString(Date.now)] ?? []
                self.doneGettingHabits = true
            }
            
        }
    }
    
    // Function for creating a blank slate of Habits to track for a new day based on the user's blueprint
    func translateNewDay() {
        // Set up variables
        var newHabits: [Habit] = []
        let todayWeekday = mapIntToWeekday(Calendar.current.component(.weekday, from: Date.now))
        
        // Pick out the blueprints that apply to the current day, and turn them into Habits
        for blueprint in blueprints {
            if blueprint.recurringDays.contains(todayWeekday) {
                let newHabit = Habit(key: UUID().uuidString, name: blueprint.name, date: Date.now, importance: blueprint.importance, color: blueprint.color, isComplete: false)
                newHabits.append(newHabit)
            }
        }
        
        // Persist the new data
        let db = Firestore.firestore()
        let habitsCollection = db.collection("Habits")
        
        for habit in newHabits {
            var newData: [String:Any] = [:]
            newData["name"] = habit.name
            newData["importance"] = habit.importance
            newData["isComplete"] = habit.isComplete
            newData["uid"] = user.uid
            newData["date"] = dateToString(Date.now)
            
            let colorValues = NSColor(habit.color).cgColor.components ?? [0, 0, 0, 0]
            newData["red"] = Double(colorValues[0]) * 100
            newData["green"] = Double(colorValues[1]) * 100
            newData["blue"] = Double(colorValues[2]) * 100
            
            let document = habitsCollection.document(habit.key)
            
            document.setData(newData) { error in
                if let error {
                    print("Error creating new habit \(error)")
                } else {
                    print("Successfully added a habit \(habit.name)")
                }
            }
        }
        
        // Add the array of Habits into the dictionary
        self.habits[dateToString(Date.now)] = newHabits
        self.todayHabits = newHabits
    }
    
    // Based on state changes, update the stats to reflect the data
    func updateStats() {
        var numberCompleted: Int = 0
        for habit in todayHabits {
            if habit.isComplete {
                numberCompleted += 1
            }
        }
        
        let today = dateToString(Date.now)
        
        if self.stats[today] == nil {
            self.stats[today] = Record(numberComplete: 0, numberTotal: 0)
        }
        
        self.stats[today]?.numberComplete = numberCompleted
        self.stats[today]?.numberTotal = self.todayHabits.count
        
        // Persist the data
        let db = Firestore.firestore()
        db.collection("Stats").document(user.uid).setData([dateToString(Date.now):"\(numberCompleted),\(self.todayHabits.count)"], merge: true) { error in
            if let error {
                print("Error persisting the stats \(error)")
            } else {
                print("Successfully persisted the stats")
            }
        }
        
    }
    
    
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
    
    // Create and persist a new blueprint and associated habit
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
        
        
        let todayWeekday = Calendar.current.component(.weekday, from: Date.now)
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
            
            // Update stats & sort habits
            let today = dateToString(Date.now)
            habits[today] = todayHabits
            updateStats()
            sortHabits()
            
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
    
    
    // change the completion status of a habit
    func updateCompletion(habit: Habit) {
        // Update the statistics
        updateStats()
        sortHabits()
        
        // persist the new data
        let db = Firestore.firestore()
        
        let document = db.collection("Habits").document(habit.key)
        
        document.setData(habit.encodeToStorage(), merge: true) { error in
            if let error {
                print("Error updating the habit data \(error)")
            } else {
                print("Successfully updated the \(habit.name) habit to be completed: \(habit.isComplete)")
            }
        }
    }
}
