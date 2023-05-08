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
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(.red)
                InputFieldsView(name: $name, description: $description, importance: $importance, color: $color)
                WeekdaysPickerView(monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday)
                Button(action: {
                    if checkNewBlueprint() {
                        addBlueprint()
                        inertiaViewModel.addMode = false
                        inertiaViewModel.editMode = false
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
            }
                .padding()
                .frame(width: 350, height: 400)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
        }
    }
    
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
    
    func addBlueprint() {
        print("Adding a blueprint")
        
        var newData: [String:Any] = [:]
        newData["name"] = self.name
        newData["description"] = self.description
        newData["importance"] = self.importance
        let colorValues = NSColor(self.color).cgColor.components ?? [0, 0, 0, 0]
        newData["red"] = Double(colorValues[0]) * 100
        newData["green"] = Double(colorValues[1]) * 100
        newData["blue"] = Double(colorValues[2]) * 100
        newData["uid"] = inertiaViewModel.user.uid
        newData["email"] = inertiaViewModel.user.email
        
        newData["monday"] = self.monday
        newData["tuesday"] = self.tuesday
        newData["wednesday"] = self.wednesday
        newData["thursday"] = self.thursday
        newData["friday"] = self.friday
        newData["saturday"] = self.saturday
        newData["sunday"] = self.sunday
        
        var blueprintDays: [Days] = []
        if monday {blueprintDays.append(.monday)}
        if tuesday {blueprintDays.append(.tuesday)}
        if wednesday {blueprintDays.append(.wednesday)}
        if thursday {blueprintDays.append(.thursday)}
        if friday {blueprintDays.append(.friday)}
        if saturday {blueprintDays.append(.saturday)}
        if sunday {blueprintDays.append(.sunday)}
        
        
        let db = Firestore.firestore()
        let key = UUID().uuidString
        let document = db.collection("Blueprints").document(key)
        
        document.setData(newData) { error in
            if let error {
                print("Error creating new blueprint \(error)")
            } else {
                print("Successfully added a blueprint")
                self.blueprints.append(HabitBlueprint(name: self.name, description: self.description, days: blueprintDays, color: self.color, importance: self.importance, key: key))
            }
        }
        
        
        
        var todayWeekday = Calendar.current.component(.weekday, from: Date.now)
        var shouldAddHabit = false
        
        switch todayWeekday {
        case 1:
            if sunday == true {
                shouldAddHabit = true
            }
        case 2:
            if monday == true {
                shouldAddHabit = true
            }
        case 3:
            if tuesday == true {
                shouldAddHabit = true
            }
        case 4:
            if wednesday == true {
                shouldAddHabit = true
            }
        case 5:
            if thursday == true {
                shouldAddHabit = true
            }
        case 6:
            if friday == true {
                shouldAddHabit = true
            }
        case 7:
            if saturday == true {
                shouldAddHabit = true
            }
        default:
            shouldAddHabit = false
        }
        
        
        if shouldAddHabit {
            
            let newHabit = Habit(key: UUID().uuidString, name: self.name, date: Date.now, importance: self.importance, color: self.color, isComplete: false)
            self.habits.append(newHabit)
            
            // Update stats
            let today = inertiaViewModel.dateToString(Date.now)
            inertiaViewModel.habits[today] = inertiaViewModel.todayHabits
            inertiaViewModel.updateStats()
            
            var newData: [String:Any] = [:]
            newData["name"] = newHabit.name
            newData["importance"] = newHabit.importance
            newData["isComplete"] = newHabit.isComplete
            newData["uid"] = inertiaViewModel.user.uid
            newData["date"] = dateToString(newHabit.date)
            
            let colorValues = NSColor(newHabit.color).cgColor.components ?? [0, 0, 0, 0]
            newData["red"] = Double(colorValues[0]) * 100
            newData["green"] = Double(colorValues[1]) * 100
            newData["blue"] = Double(colorValues[2]) * 100
            
            let db = Firestore.firestore()
            let habitsCollection = db.collection("Habits")
            let document = habitsCollection.document(newHabit.key)
            
            document.setData(newData) { error in
                if let error {
                    print("Error creating new habit \(error)")
                } else {
                    print("Successfully added a habit \(newHabit.name)")
                }
            }
        }
    }
    
    // Helper function for getting the string translation
    func dateToString(_ dateIn: Date) -> String {
        return dateIn.formatted(
                        .dateTime
                            .day().month().year()
                        )
    }
    
    
    // Helper function for mapping weekday component of a date, which is an Int, to a Days enum value
    private func mapIntToWeekday(_ intIn: Int) -> Days {
        return .sunday
    }

}

//struct NewBlueprintView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewBlueprintView()
//    }
//}
