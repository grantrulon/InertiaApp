//
//  User.swift
//  Inertia
//
//  Created by Grant Rulon on 4/17/23.
//

import Foundation


class User {
    var name: String = ""
    var email: String = ""
    var uid: String = ""
    var isLoggedIn: Bool = false
    
    var blueprints: [HabitBlueprint] = []
    var stats: [Record] = []
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
