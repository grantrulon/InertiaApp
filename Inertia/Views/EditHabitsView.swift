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
    
    @State var showingPopover = false
    
    var newData: [String:Any] = [
        "name": "new",
        "description": "new description",
        "uid": "2sNYIIlMajX0CVWs6XKM60W07Kb2",
        "userEmail": "test@test.com"
    ]
    
    let blueprintPositions: [OffsetCoordinate] = [
        .init(row: 0, col: 0),
        .init(row: 1, col: 0),
        .init(row: 0, col: 1),
        .init(row: 1, col: 1),
        .init(row: 0, col: 2)
    ]
    
    @State var width: CGFloat = 200
    @State var height: CGFloat = 200
    
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
    
    var editGrid = [GridItem(.adaptive(minimum: 140))]
    
    let colors = [Color.blue, .green, .red, .pink, .orange, .teal, .purple, .gray, .yellow]
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: editGrid) {
//                ForEach(habitBlueprints) { blueprint in
//                    ZStack {
//                        Color(.red)
//                            .frame(width: CGFloat(Int.random(in: 50...100)), height: CGFloat(Int.random(in: 50...100)))
//                        Text(blueprint.name)
//                    }
//                }
//                Circle()
//                    .fill(.black)
//                    .frame(width: 100)
//
//                ForEach(colors.indices, id: \.self) { idx in
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(colors[idx])
//                        .frame(width: CGFloat(Int.random(in: 50...150)), height: CGFloat(Int.random(in: 50...150)))
//                        .overlay(Text("\(idx)"))
//                }
                
                ForEach(habitBlueprints, id: \.id) { blueprint in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(blueprint.color)
                        .frame(width: CGFloat(blueprint.importance * 50), height: CGFloat(blueprint.importance * 50))
                        .overlay(
                            VStack {
                                Text(blueprint.name)
                                Text(blueprint.description)
                            }
                        )
                }
            }
        }
        
//        VStack {
//            HStack {
//                Button("?") {
//                    showingPopover = true
//                }
//                .background(Color.blue)
//                .cornerRadius(38.5)
//                .padding()
//                .popover(isPresented: $showingPopover) {
//                    Text("Instructions")
//                }
//                Spacer()
//                Button(action: editMode) {
//                    Text("Edit")
//                        .frame(width: 50, height: 25)
//                }
//                .background(Color.blue)
//                .cornerRadius(38.5)
//                Button(action: addBlueprintItem) {
//                    Text("+")
//                        .frame(width: 25, height: 25)
//                }
//                .background(Color.blue)
//                .cornerRadius(38.5)
//                .padding()
//            }
//            .buttonStyle(.borderedProminent)
//            ScrollView([.horizontal, .vertical]) {
//                HexGrid(habitBlueprints, spacing: 2.0) { blueprint in
//                    ZStack {
//                        blueprint.color
//                        HStack {
//                            Text(blueprint.name)
//        //                        .onTapGesture {
//        //                            print("Clicking on \(blueprint.name)")
//        //                        }
//                            DeleteButton(blueprints: $habitBlueprints, name: blueprint.name, key: blueprint.key)
//                        }
//
//                    }
//
//                }
//                .frame(width: self.width, height: self.height)
//                .scaleEffect(scale)
//                .gesture(magnification)
//            }
//
//        }
//        .background(Color.gray.opacity(0.0))
    }
    
    func addBlueprintItem() {
        self.habitBlueprints.append(HabitBlueprint(name: "new", description: "new", color: .blue, importance: 10, mode: .fullCompletion, offsetCoordinate: .init(row: 1, col: 0), key: "New Document"))
        
        // add to the database
        let db = Firestore.firestore()
        
        let document = db.collection("Blueprints").document(UUID().uuidString)
        
        document.setData(newData) { error in
            if let error {
                print("Error creating new blueprint \(error)")
            } else {
                print("Successfully added a blueprint")
            }
        }
        width += 100
        height += 100
        
        arrangeBlueprints()
    }
    
    func arrangeBlueprints() {
        for (i, blueprint) in habitBlueprints.enumerated() {
            blueprint.offsetCoordinate = blueprintPositions[i];
        }
    }
    
    func editMode() {
        print("Edit Mode")
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
