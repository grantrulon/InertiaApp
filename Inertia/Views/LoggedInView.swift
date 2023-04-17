//
//  LoggedInView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/17/23.
//

import SwiftUI

struct LoggedInView: View {
    @Binding var user: User
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            Text("Welcome \(user.email)!!")
            Button(action: logout) {
                Text("Logout")
            }
        }
        
    }
    
    
    func logout() {
        user.isLoggedIn = false
        self.isLoggedIn = false
    }
}

//struct LoggedInView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoggedInView()
//    }
//}
