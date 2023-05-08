//
//  HabitCard.swift
//  Inertia
//
//  Created by Grant Rulon on 4/12/23.
//

import SwiftUI
import FirebaseFirestore



struct HabitCard: View {
    
    @Binding var habit: Habit
    @ObservedObject var inertiaViewModel: InertiaViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text(String(habit.importance))
                    .bold()
                    .padding()
                    .foregroundColor(.white)
                    .overlay(Circle().stroke(.white, lineWidth: 1)
                        .frame(width: 35, height: 35)
                        )
                Text(habit.name)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
                Toggle(isOn: $habit.isComplete, label: {
                    Text("")
                })
                .onChange(of: habit.isComplete, perform: { value in
                    updateCompletion()
                })
                .toggleStyle(CheckboxStyle())
            }
        }
        .padding(16)
        .frame(height: 50)
        .background(habit.color.opacity(habit.isComplete ? 0.5 : 1.0))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

    }
    
    func updateCompletion() {
        // Update the statistics
        inertiaViewModel.updateStats()
        inertiaViewModel.sortHabits()
        
        let db = Firestore.firestore()
        
        let document = db.collection("Habits").document(self.habit.key)
        
        document.setData(habit.encodeToStorage(), merge: true) { error in
            if let error {
                print("Error updating the habit data \(error)")
            } else {
                print("Successfully updated the \(habit.name) habit to be completed: \(habit.isComplete)")
            }
        }
    }
    
//
//    func updateData() {
//        if habit.mode == .fullCompletion && isToggleOn {
//            habit.completionPoints = habit.totalPoints
//        } else if habit.mode == .fullCompletion && !isToggleOn {
//            habit.completionPoints = 0
//        }
//        print("Updating \(habit.name) to have \(habit.completionPoints)")
//    }
}

//struct HabitCard_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCard()
//    }
//}


// https://www.appcoda.com/swiftui-toggle-style/
struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
 
            configuration.label
 
            Spacer()
 
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .white : .white)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
 
    }
}
