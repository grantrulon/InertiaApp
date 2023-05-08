//
//  DeleteButton.swift
//  Inertia
//
//  Created by Grant Rulon on 4/17/23.
//

import SwiftUI
import FirebaseFirestore

struct DeleteButton: View {
    @Binding var blueprints: [HabitBlueprint]
    @Binding var habits: [Habit]
    var name: String
    var key: String
    
    @Binding var editMode: Bool
    @ObservedObject var inertiaViewModel: InertiaViewModel
    
    var body: some View {
        if editMode {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: deleteBlueprint) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
            }
        }
        
        
    }
    
    func deleteBlueprint() {
        
        
        self.editMode = false
        let index = blueprints.firstIndex {
            $0.name == self.name
        }
        if let index {
            blueprints.remove(at: index)
        } else {
            print("did not find the blueprint you want to delete")
        }
        
        var habitKey: String = ""
        let habitIndex = habits.firstIndex {
            $0.name == self.name
        }
        if let habitIndex {
            habitKey = habits[habitIndex].key
            habits.remove(at: habitIndex)
        } else {
            print("There are no habits with this name to delete")
        }
        
        // Update stats
        let today = inertiaViewModel.dateToString(Date.now)
        inertiaViewModel.habits[today] = inertiaViewModel.todayHabits
        inertiaViewModel.updateStats()
        
        // Delete from database
        let db = Firestore.firestore()
        
        db.collection("Blueprints").document(self.key).delete() { error in
            if let error {
                print("Error deleting Blueprint \(error)")
            } else {
                print("Successfully deleted Blueprint document \(key)")
            }
        }
        
        
        for habit in habits {
            if habit.name == self.name {
                habitKey = habit.key
            }
        }
        
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

//struct DeleteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteButton()
//    }
//}
