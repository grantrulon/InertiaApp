//
//  EditHabitsView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/11/23.
//

import SwiftUI
import HexGrid
import FirebaseFirestore

struct EditHabitsView: View {
    
    @Binding var uid: String
    @Binding var email: String
    
    @Binding var habitBlueprints: [HabitBlueprint]
    @Binding var habits: [Habit]
    @Binding var editMode: Bool
    @Binding var addMode: Bool
    @ObservedObject var inertiaViewModel: InertiaViewModel
    
    @State var showingPopover = false
    
    var editGrid = [GridItem(.adaptive(minimum: 250), spacing: 16)]
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    editMode.toggle()
                }, label: {
                    Text("Edit")
                        .foregroundColor(.white)
                })
                .buttonStyle(.plain)
                .frame(width: 70, height: 40)
                .background(Color.gray)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                .padding()
            }
            
            ScrollView {
                LazyVGrid(columns: editGrid, spacing: 16) {
                    if editMode {
                        Button(action: {
                            addMode = true
                        }, label: {
                            Image(systemName: "plus.app")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        })
                        .buttonStyle(.plain)
                    }
                    ForEach(habitBlueprints, id: \.id) { blueprint in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(blueprint.name)
                                    .bold()
                                    .foregroundColor(.white)
                                Spacer()
                                Text(String(blueprint.importance))
                                    .bold()
                                    .padding()
                                    .foregroundColor(.white)
                                    .overlay(Circle().stroke(.white, lineWidth: 1)
                                        .frame(width: 35, height: 35)
                                        )
                            }
                            Text(blueprint.description)
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.8))
                            HStack {
                                ForEach(Days.allCases, id: \.rawValue) { day in
                                    if blueprint.recurringDays.contains(day) {
                                        Text(day.rawValue)
                                            .foregroundColor(.white)
                                    } else {
                                        Text(day.rawValue)
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(blueprint.color)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: blueprint.color.opacity(0.3), radius: 20, x: 0, y: 10)
                        .overlay(
                            DeleteButton(blueprints: $habitBlueprints, habits: $habits, name: blueprint.name, key: blueprint.key, editMode: $editMode, inertiaViewModel: inertiaViewModel)
                        )
                    }
                }
            }
            .padding(16)
            .overlay(NewBlueprintView(uid: $uid, email: $email, addMode: $addMode, editMode: $editMode, blueprints: $habitBlueprints, habits: $habits, inertiaViewModel: inertiaViewModel))
            
        }
        
        
    }
    
    
}






//struct EditHabitsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditHabitsView()
//    }
//}
