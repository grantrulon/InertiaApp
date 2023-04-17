//
//  HabitCard.swift
//  Inertia
//
//  Created by Grant Rulon on 4/12/23.
//

import SwiftUI

struct HabitCard: View {
    
    var habit: Habit
    @State var partialCompletionProgress: Int
    @State var isToggleOn: Bool = false
    
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
                    TextField("Progress:", value: $partialCompletionProgress, format: .number)
                        .frame(width: 25)
                case .fullCompletion:
                    Toggle("Toggle", isOn: $isToggleOn)
                }
            }
            .padding()
        }
        .frame(height: 50.0)
        .cornerRadius(8.0)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(habit.color, lineWidth: 5)
        )

    }
}

//struct HabitCard_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCard()
//    }
//}
