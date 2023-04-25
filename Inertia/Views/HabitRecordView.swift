//
//  HabitRecordView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/12/23.
//

import SwiftUI

struct HabitRecordView: View {
    
    @Binding var todayHabits: [Habit]
    
    var body: some View {
        List {
            ForEach(0..<todayHabits.count, id: \.self) { i in
                VStack {
                    HabitCard(habit: $todayHabits[i], partialCompletionProgress: 0)
                }
            }
            Button("Hello") {
                todayHabits.append(Habit(name: "test", description: "test", date: .now, importance: 1, mode: .fullCompletion, color: .red))
            }
        }
        .frame(width: 500.0)
        .frame(maxHeight: 500.0)
        .padding(.leading)
    }
}

//struct HabitRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitRecordView()
//    }
//}


// TODO: Future Work
// - Add functionality for 
