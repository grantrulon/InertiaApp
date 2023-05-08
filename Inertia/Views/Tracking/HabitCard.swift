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
                    inertiaViewModel.updateCompletion(habit: habit)
                })
                .toggleStyle(CheckboxStyle())
            }
        }
        .padding(16)
        .frame(height: 50)
        .background(habit.color.opacity(habit.isComplete ? 0.5 : 1.0))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

    }
    
    
    
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
