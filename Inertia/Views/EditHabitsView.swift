//
//  EditHabitsView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/11/23.
//

import SwiftUI
import HexGrid
import FirebaseFirestore

struct EditHabitsView: View {
    
    
    @Binding var habitBlueprints: [HabitBlueprint]
    
    @State var scale = 1.0
    @State var previousScale = 1.0
//
//    @Binding var nextX: Int
//    @Binding var nextY: Int
    
    var newData: [String:Any] = [
        "name": "new",
        "description": "new description",
        "uid": "2sNYIIlMajX0CVWs6XKM60W07Kb2",
        "userEmail": "test@test.com"
    ]
    
    
    // https://www.youtube.com/watch?v=Gq39U4mJEY4
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { newScale in
                let scaleFactor = newScale / previousScale
                scale *= scaleFactor
                previousScale = newScale
            }
            .onEnded { newScale in
                previousScale = 1.0
            }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: addBlueprintItem) {
                    Text("+")
                        .frame(width: 25, height: 25)
                }
                .background(Color.blue)
                .cornerRadius(38.5)
                
                .padding()
            }
            .buttonStyle(.borderedProminent)
            ScrollView([.horizontal, .vertical]) {
                HexGrid(habitBlueprints) { blueprint in
                    ZStack {
                        blueprint.color
                        HStack {
                            Text(blueprint.name)
        //                        .onTapGesture {
        //                            print("Clicking on \(blueprint.name)")
        //                        }
                            DeleteButton(blueprints: $habitBlueprints, name: blueprint.name, key: blueprint.key)
                        }
                        
                    }
                    
                }
                .frame(minWidth: 200, minHeight: 200)
                .scaleEffect(scale)
                .gesture(magnification)
            }
            
        }
    }
    
    func addBlueprintItem() {
        self.habitBlueprints.append(HabitBlueprint(name: "new", description: "new", color: .blue, importance: 10, mode: .fullCompletion, offsetCoordinate: .init(row: 1, col: 0), key: "New Document"))
        
        // add to the database
        let db = Firestore.firestore()
        
        let document = db.collection("Blueprints").document("New Document")
        
        document.setData(newData) { error in
            if let error {
                print("Error creating new blueprint \(error)")
            } else {
                print("Successfully added a blueprint")
            }
        }
    }
    
}

struct HexCell: Identifiable, OffsetCoordinateProviding {
    var id: Int { offsetCoordinate.hashValue }
    var offsetCoordinate: OffsetCoordinate
    var colorName: Color
}





//struct EditHabitsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditHabitsView()
//    }
//}
