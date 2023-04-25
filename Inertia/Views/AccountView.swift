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
    
    @State var errorInformation: String = ""
    
//    @Binding var nextX: Int
//    @Binding var nextY: Int
    
    @State var localBlueprints: [HabitBlueprint] = []
    @Binding var blueprints: [HabitBlueprint]
    
    @State var tabSelected: Int = 0
    
    
    var body: some View {
        VStack {
            
            HStack {
                Button(action: {
                    withAnimation(.spring()) {
                        tabSelected = 0
                    }
                }, label: {
                    VStack {
                        Text("Login")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(tabSelected == 0 ? .black : .gray.opacity(0.2))
                        Capsule()
                            .fill(tabSelected == 0 ? .blue : .gray.opacity(0.1))
                            .frame(height: 5)
                    }
                    
                })
                
                Button(action: {
                    withAnimation(.spring()) {
                        tabSelected = 1
                    }
                }, label: {
                    VStack {
                        Text("Sign Up")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(tabSelected == 1 ? .black : .gray.opacity(0.2))
                        Capsule()
                            .fill(tabSelected == 1 ? .blue : .gray.opacity(0.1))
                            .frame(height: 5)
                    }
                    
                })
            }
            .buttonStyle(.plain)
            .padding(.bottom, 15)
            
            
            if tabSelected == 0 {
                Text("Welcome!")
                    .font(.system(.title).bold())
                Text(errorInformation)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(.red)
                HStack {
                    Text("Email:")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.secondary)
                        .frame(height: 15, alignment: .leading)
                    Spacer()
                }
                TextField("", text: $email)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.primary)
                    .frame(height: 40)
                    .padding(.horizontal, 12)
                    .background(.white)
                    .cornerRadius(4.0)
                    .onSubmit {
                        login()
                    }
                
                HStack {
                    Text("Password:")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.secondary)
                        .frame(height: 15, alignment: .leading)
                    Spacer()
                }
                SecureField("", text: $password)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.primary)
                    .frame(height: 40)
                    .padding(.horizontal, 12)
                    .background(.white)
                    .cornerRadius(4.0)
                    .onSubmit {
                        login()
                    }
                
                Button(action: login) {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 200, height: 36, alignment: .center)
                }
                .buttonStyle(.plain)
                .background(.secondary)
                .cornerRadius(4)
                .padding(.top, 15)
                
            } else if tabSelected == 1 {
                CreateAccountView(isLoggedIn: $isLoggedIn, user: $user)
            }
        }
        
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.errorInformation = error?.localizedDescription ?? ""
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
