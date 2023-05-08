//
//  HabitRecordView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/12/23.
//

import SwiftUI

struct HabitRecordView: View {
    
    @Binding var todayHabits: [Habit]
    @ObservedObject var inertiaViewModel: InertiaViewModel
    
    var body: some View {
        List {
            if let todayHabits {
                ForEach(0..<todayHabits.count, id: \.self) { i in
                    VStack {
                        HabitCard(habit: $todayHabits[i], inertiaViewModel: inertiaViewModel)
                    }
                }
            }
        }
    }
}

//struct HabitRecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        HabitRecordView()
//    }
//}

