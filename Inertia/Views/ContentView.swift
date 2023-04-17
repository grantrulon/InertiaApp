//
//  ContentView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/10/23.
//

import SwiftUI


enum SidebarMenuSelections: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case edit
    case track
    case account
    case stats
}

struct ContentView: View {
    @StateObject var inertiaViewModel = InertiaViewModel()
//    @State var isLoggedIn = false
    
    // https://www.youtube.com/watch?v=8buuKon6ZdQ
    @State var visibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedMenuItem: SidebarMenuSelections = .edit
    
//    var blueprints: [HabitBlueprint] = [
//        HabitBlueprint(name: "Work Out", description: "Lift", color: .blue, importance: 9, mode: .fullCompletion, offsetCoordinate: .init(row: 0, col: 1), ),
//        HabitBlueprint(name: "Drink Water", description: "3 Liters", color: .red, importance: 5, mode: .partialCompletion, offsetCoordinate: .init(row: 1, col: 0))
//    ]
    //
    //    var simpleDrag: some Gesture {
    //        DragGesture()
    //            .onEnded { value in
    //
    //            } .onChanged { value in
    //                self.isMoving = true
    //                self.circlePosition1 = value.location
    //            }
    //    }
    
    var body: some View {
        HStack {
            NavigationSplitView(columnVisibility: $visibility) {
                List(SidebarMenuSelections.allCases, selection: $selectedMenuItem) { item in
                    NavigationLink(item.rawValue, value: item)
                }
            } detail: {
                switch selectedMenuItem {
                case .edit:
                    EditHabitsView(habitBlueprints: $inertiaViewModel.blueprints)
                    //                    Text("Edit")
                case .track:
                    HabitRecordView(habits: [Habit(name: "habit1", description: "Desc", date: .now, importance: 10, mode: .fullCompletion, color: .red), Habit(name: "Habit2", description: "Desc", date: .now, importance: 4, mode: .partialCompletion, color: .blue)])
                    //                    ZStack {
                    //                        Color(.blue)
                    //                        ScrollView {
                    //                            Text("Scroll")
                    //                        }
                    //                    }
                    //                    Canvas { context, size in
                    //                        context.
                    //                    }
                    //                    .frame(width: 200, height: 200)
                case .account:
                    if inertiaViewModel.isLoggedIn {
                        LoggedInView(user: $inertiaViewModel.user, isLoggedIn: $inertiaViewModel.isLoggedIn)
                    } else {
                        AccountView(isLoggedIn: $inertiaViewModel.isLoggedIn, user: $inertiaViewModel.user, blueprints: $inertiaViewModel.blueprints)
                    }
                case .stats:
                    Text("Stats View")
                }
            }
        }
    }
}

          
            
    


//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}


