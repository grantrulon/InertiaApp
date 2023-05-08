//
//  NewBlueprintView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/26/23.
//

import SwiftUI
import FirebaseFirestore

struct NewBlueprintView: View {
    
    @State var name: String = ""
    @State var description: String = ""
    @State var importance: Int = 1
    @State var color: Color = .blue
    
    @State var monday: Bool = false
    @State var tuesday: Bool = false
    @State var wednesday: Bool = false
    @State var thursday: Bool = false
    @State var friday: Bool = false
    @State var saturday: Bool = false
    @State var sunday: Bool = false
    
    @State var errorInformation: String = ""
    
    @Binding var blueprints: [HabitBlueprint]
    @Binding var habits: [Habit]
    @ObservedObject var inertiaViewModel: InertiaViewModel
    
    var body: some View {
        if inertiaViewModel.addMode {
            VStack {
                Text("New Habit")
                    .font(.system(.title, weight: .bold))
                Text(errorInformation)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.red)
                InputFieldsView(name: $name, description: $description, importance: $importance, color: $color)
                WeekdaysPickerView(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)
                Button(action: {
                    if checkNewBlueprint() {
                        inertiaViewModel.addBlueprint(name: name, description: description, importance: importance, color: color, monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday, sunday: sunday)
                        inertiaViewModel.addMode = false
                        inertiaViewModel.editMode = false
                        name = ""
                        description = ""
                    }
                }, label: {
                    Text("Add")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 200, height: 36, alignment: .center)
                })
                .buttonStyle(.plain)
                .background(.secondary)
                .cornerRadius(4)
                .padding(.top, 15)
                Button(action: {
                    inertiaViewModel.addMode = false
                    name = ""
                    description = ""
                }, label: {
                    Text("Cancel")
                        .font(.system(size: 11))
                })
                .buttonStyle(.plain)
            }
                .padding()
                .frame(width: 350, height: 400)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
        }
    }
    
    
    // Check if the possible new blueprint meets the standards
    private func checkNewBlueprint() -> Bool {
        // Check required fields
        if name == "" || description == "" {
            errorInformation = "Name & Description are required"
            return false
        }
        
        // Check that the name is
        for blueprint in blueprints {
            if blueprint.name == name {
                errorInformation = "Duplicate names are not allowed"
                return false
            }
        }
        
        // All checks run
        errorInformation = ""
        return true
    }

}

//struct NewBlueprintView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewBlueprintView()
//    }
//}
