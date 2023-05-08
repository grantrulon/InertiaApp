//
//  InertiaViewModel_DatabaseOperations.swift
//  Inertia
//
//  Created by Grant Rulon on 5/8/23.
//

import Foundation
import FirebaseFirestore

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
        
        
//        for habit in todayHabits {
//            if habit.name == name {
//                habitKey = habit.key
//            }
//        }
        
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
}
