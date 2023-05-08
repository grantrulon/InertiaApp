//
//  HabitCompletionView.swift
//  Inertia
//
//  Created by Grant Rulon on 5/7/23.
//

import SwiftUI

struct HabitCompletionView: View {
    var habits: [Habit]?
    
    var body: some View {
        VStack {
            if let habits {
                HStack {
                    Spacer()
                    VStack {
                        Text("Completed:")
                            .font(.system(size: 18, weight: .bold))
                        ForEach(habits, id: \.id) { habit in
                            if habit.isComplete {
                                Text(habit.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Text("Uncompleted:")
                            .font(.system(size: 18, weight: .bold))
                        ForEach(habits, id: \.id) { habit in
                            if !habit.isComplete {
                                Text(habit.name)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

//struct HabitCompletionView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitCompletionView()
//    }
//}
