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
    var name: String
    var key: String
    
    var body: some View {
        Button(action: deleteBlueprint) {
            Text("Delete")
        }
    }
    
    func deleteBlueprint() {
        var index = blueprints.firstIndex {
            $0.name == self.name
        }
        if let index {
            blueprints.remove(at: index)
        } else {
            print("did not find the blueprint you want to delete")
        }
        
        // Delete from database
        let db = Firestore.firestore()
        
        db.collection("Blueprints").document(self.key).delete() { error in
            if let error {
                print("Error deleting \(error)")
            } else {
                print("Successfully deleted document \(key)")
            }
        }
    }
}

//struct DeleteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteButton()
//    }
//}
