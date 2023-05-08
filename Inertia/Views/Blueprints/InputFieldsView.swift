//
//  InputFieldsView.swift
//  Inertia
//
//  Created by Grant Rulon on 5/5/23.
//

import SwiftUI

struct InputFieldsView: View {
    
    @Binding var name: String
    @Binding var description: String
    @Binding var importance: Int
    @Binding var color: Color
    var importances = [1, 2, 3, 4]
    var colors: [Color] = [.blue, .green, .red, .cyan, .purple]
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                Spacer()
            }
            TextField("", text: $name)
                .textFieldStyle(.plain)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.primary)
                .frame(height: 40)
                .padding(.horizontal, 12)
                .background(.white)
                .cornerRadius(4.0)
            HStack {
                Text("Description:")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                Spacer()
            }
            TextField("", text: $description)
                .textFieldStyle(.plain)
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.primary)
                .frame(height: 40)
                .padding(.horizontal, 12)
                .background(.white)
                .cornerRadius(4.0)
            HStack {
                Text("Importance:")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                Spacer()
            }
            Picker("", selection: $importance) {
                ForEach(importances, id: \.self) {
                    Text(String($0))
                }
            }
            .pickerStyle(.menu)
            HStack {
                Text("Color:")
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                Spacer()
            }
            Picker("", selection: $color) {
                ForEach(colors, id: \.self) {
                    Text($0.description)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

//struct InputFieldsView_Previews: PreviewProvider {
//    static var previews: some View {
//        InputFieldsView()
//    }
//}
