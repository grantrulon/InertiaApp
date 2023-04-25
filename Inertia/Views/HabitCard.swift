//
//  HabitCard.swift
//  Inertia
//
//  Created by Grant Rulon on 4/12/23.
//

import SwiftUI

struct HabitCard: View {
    
    @Binding var habit: Habit
//    @Binding var habits: [String:[Habit]]
    @State var partialCompletionProgress: Int
    @State var isToggleOn: Bool = false
    
//    @Binding var habits: [String:[Habit]]
    
    var body: some View {
        ZStack {
            Color(.lightGray)
            HStack {
                VStack {
                    Text(habit.name)
                        .fontWeight(.bold)
                    Text(habit.description)
                }
                Spacer()
                switch habit.mode {
                case .partialCompletion:
                    TextField("Progress:", value: $habit.completionPoints, format: .number)
                        .frame(width: 25)
                case .fullCompletion:
                    Toggle("Toggle", isOn: $habit.isComplete)
                        .onChange(of: habit.isComplete) { value in
//                            updateData()
//                            $habit.completionPoints = 100
                        }
                }
            }
            .padding()
        }
        .frame(height: 50.0)
        .cornerRadius(8.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .inset(by: 5)
                .stroke(habit.color, lineWidth: 5)
        )

    }
    
    
    func updateData() {
        if habit.mode == .fullCompletion && isToggleOn {
            habit.completionPoints = habit.totalPoints
        } else if habit.mode == .fullCompletion && !isToggleOn {
            habit.completionPoints = 0
        }
        print("Updating \(habit.name) to have \(habit.completionPoints)")
    }
}

//struct HabitCard_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCard()
//    }
//}
