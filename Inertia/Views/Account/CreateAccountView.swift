//
//  CreateAccountView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/24/23.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    
    @State var errorInformation: String = ""
    
    @State var email: String = ""
    @State var password: String = ""
    
    @Binding var isLoggedIn: Bool
    
    @Binding var user: User
    
    var body: some View {
        VStack {
            Text("Create Account")
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
                    createAccount()
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
                    createAccount()
                }
            
            Button(action: createAccount) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .frame(width: 200, height: 36, alignment: .center)
            }
            .buttonStyle(.plain)
            .background(.secondary)
            .cornerRadius(4)
            .padding(.top, 15)
        }
    }
    
    func createAccount() {
        print("Create Account")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.errorInformation = error?.localizedDescription ?? ""
            } else {
                print("User successfully registered: \(result)")
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error != nil {
                        print("Error logging in after creating account")
                    } else {
                        print("success")
                        print(result?.user.email)
                        print(result?.user.uid)
                        user.email = result?.user.email ?? ""
                        user.uid = result?.user.uid ?? ""
                        self.isLoggedIn = true
                        // TODO: fetch data
                    }
                }
            }
        }
    }
}

//struct CreateAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateAccountView()
//    }
//}
