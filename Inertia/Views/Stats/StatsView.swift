//
//  StatsView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/30/23.
//

import SwiftUI

struct StatsView: View {
    @Binding var habits: [String:[Habit]]
    @Binding var stats: [String:Record]
    @State var chosenDate: Date = Date.now
    
    var body: some View {
        VStack {
            HStack {
                DatePicker("", selection: $chosenDate, displayedComponents: [.date])
                        .frame(width: 310, height: 320, alignment: .center)
                        .foregroundColor(Color.red)
                        .scaleEffect(x: 2, y: 2, anchor: .leading)
                        .background(RoundedRectangle(cornerRadius: 5).fill(.blue.opacity(0.55)))
                        .datePickerStyle(GraphicalDatePickerStyle())
                Spacer()
                CircularProgressView(data: stats[self.chosenDate.formatted(.dateTime.day().month().year())])
                Spacer()
            }
            .padding()
            Spacer()
            HabitCompletionView(habits: habits[self.chosenDate.formatted(.dateTime.day().month().year())])
                .padding()
            Spacer()
            
        }
    }
}

//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsView()
//    }
//}
