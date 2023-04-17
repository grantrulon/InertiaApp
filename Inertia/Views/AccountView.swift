//
//  AccountView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/16/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct AccountView: View {
    @State var email = ""
    @State var password = ""
    @Binding var isLoggedIn: Bool
    @Binding var user: User
    
//    @Binding var nextX: Int
//    @Binding var nextY: Int
    
    @State var localBlueprints: [HabitBlueprint] = []
    @Binding var blueprints: [HabitBlueprint]
    
    
    var body: some View {
        VStack {
            TextField("Email:", text: $email)
            TextField("Password:", text: $password)
            Button(action: login) {
                Text("Login")
            }
        }
        
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
                print(result?.user.email)
                print(result?.user.uid)
                user.email = result?.user.email ?? ""
                user.uid = result?.user.uid ?? ""
                user.isLoggedIn = true
                self.isLoggedIn = true
                fetchData()
            }
        }
    }
    
    func fetchData() {
        
    }
}

//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//    }
//}
