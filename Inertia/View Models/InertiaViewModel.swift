//
//  InertiaViewModel.swift
//  Inertia
//
//  Created by Grant Rulon on 4/17/23.
//

import Foundation

import FirebaseFirestore


class InertiaViewModel: ObservableObject {
    @Published var user: User = User(name: "", email: "") {
        didSet {
            print(self.user.isLoggedIn)
        }
    }
    
    @Published var isLoggedIn = false {
        didSet {
            print("\(isLoggedIn)")
            if isLoggedIn {
                fetchData()
            } else {
                blueprints = []
            }
        }
    }
    
    @Published var blueprints: [HabitBlueprint] = []
    
    func fetchData() {
        let db = Firestore.firestore()
        
        db.collection("Blueprints").getDocuments() { (results, error) in
            if let error {
                print("Error getting blueprint data")
            } else {
                for document in results!.documents {
                    print("\(document.documentID): \(document.data())")
                    let data = document.data()
                    let uid = data["uid"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    print("HERE@ \(uid)")
                    if uid == self.user.uid {
                        self.blueprints.append(HabitBlueprint(name: name, description: description, color: .gray, importance: 10, mode: .fullCompletion, offsetCoordinate: .init(row: 0, col: 0), key: document.documentID))
                    }
                }
            }
            
        }
        
    }

}
