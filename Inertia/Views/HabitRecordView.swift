//
//  HabitRecordView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/12/23.
//

import SwiftUI

struct HabitRecordView: View {
    
    // ObservedObject??
    var habits: [Habit]
    
    var body: some View {
        List {
            ForEach(habits) { habit in
                HabitCard(habit: habit, partialCompletionProgress: 0)
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
