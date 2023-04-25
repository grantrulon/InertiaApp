//
//  InertiaViewModel.swift
//  Inertia
//
//  Created by Grant Rulon on 4/17/23.
//

import Foundation
import FirebaseFirestore
import HexGrid


class InertiaViewModel: ObservableObject {
    @Published var user: User = User(name: "", email: "")
    
    @Published var isLoggedIn = false {
        didSet {
            if isLoggedIn {
                fetchData()
                
            } else {
                blueprints = []
            }
        }
    }
    
    @Published var blueprints: [HabitBlueprint] = []
//    @Published var habits: [Habit] = []
    @Published var habits: [String:[Habit]] = [:]
    @Published var todayHabits: [Habit] = [] {
        didSet {
            print("changed todayHabits to \(todayHabits)")
        }
    }
    
    let blueprintPositions: [OffsetCoordinate] = [
        .init(row: 0, col: 0),
        .init(row: 1, col: 0),
        .init(row: 0, col: 1),
        .init(row: 1, col: 1),
        .init(row: 0, col: 2)
    ]
    
    func fetchData() {
        let db = Firestore.firestore()
        
        // Fetch the blueprint data
        db.collection("Blueprints").getDocuments() { (results, error) in
            if let error {
                print("Error getting blueprint data: \(error)")
            } else {
                
                // Loop through the documents and get the current user's blueprint information
                var i = 0
                for document in results!.documents {
                    print("\(document.documentID): \(document.data())")
                    let data = document.data()
                    let uid = data["uid"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    print("HERE@ \(uid)")
                    if uid == self.user.uid {
                        self.blueprints.append(HabitBlueprint(name: name, description: description, color: .gray, importance: 10, mode: .fullCompletion, offsetCoordinate: self.blueprintPositions[i], key: document.documentID))
                        i += 1
                    }
                }
            }
            
        }
        
        // Fetch the habit history data
        habits[Date.now.formatted(.dateTime.day().month().year())] = [Habit(name: "Exercise", description: "Go for a mile run", date: .now, importance: 3, mode: .fullCompletion, color: .red)]
        todayHabits = habits[Date.now.formatted(.dateTime.day().month().year())] ?? []
        
    }
    
    

}
