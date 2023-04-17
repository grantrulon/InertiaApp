//
//  EditHabitsView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/11/23.
//

import SwiftUI
import HexGrid

struct EditHabitsView: View {
    
    
    var habitBlueprints: [HabitBlueprint]
    
    @State var scale = 1.0
    @State var previousScale = 1.0
    
    
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
    
//    var clickDrag: some Gesture {
//        DragGesture()
//            .onChanged { newLocation in
//                location = newLocation.location
//            }
//    }
    
    var body: some View {
//        ScrollView([.horizontal, .vertical]) {
            HexGrid(habitBlueprints) { blueprint in
                ZStack {
                    blueprint.color
                    Text(blueprint.name)
//                        .foregroundColor(.white)
//                        .onTapGesture {
//                            print("Clicking on \(blueprint.name)")
//                        }
//                        .onHover {_ in
//                            print("Hovering on \(blueprint.name)")
//                        }
                }
                
            }
//            .scaleEffect(scale)
//            .gesture(magnification)
//        }
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
