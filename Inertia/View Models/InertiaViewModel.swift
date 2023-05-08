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
                habits = [:]
                stats = [:]
                user.name = ""
                user.email = ""
                user.uid = ""
            }
        }
    }
    
    @Published var editMode = false
    @Published var addMode = false
    
    @Published var stats: [String:Record] = [:]
    @Published var blueprints: [HabitBlueprint] = []
    @Published var habits: [String:[Habit]] = [:]
    @Published var todayHabits: [Habit] = [] {
        didSet {
            print("Just set today's habits with: \(todayHabits)")
        }
    }
    
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
        }
    }
    
    func fetchData() {
        // Create a database instance
        let db = Firestore.firestore()
        
        // Fetch the blueprint data
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
        
        
        
        
        // Fetch the habit history data
//        habits[Date.now.formatted(.dateTime.day().month().year())] = [Habit(name: "Exercise", description: "Go for a mile run", date: .now, importance: 3, color: .red)]
//        todayHabits = habits[Date.now.formatted(.dateTime.day().month().year())] ?? []
        
    }
    
    
    // Function for creating a blank slate of Habits to track for a new day based on the user's blueprint
    func translateNewDay() {
        // Set up variables
        var newHabits: [Habit] = []
        var todayWeekday = mapIntToWeekday(Calendar.current.component(.weekday, from: Date.now))
        
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
    
    
    
    // Helper function for mapping weekday component of a date, which is an Int, to a Days enum value
    private func mapIntToWeekday(_ intIn: Int) -> Days {
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
    
    
    // Reorder the recorded habits
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
