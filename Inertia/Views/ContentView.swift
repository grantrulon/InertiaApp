//
//  ContentView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/10/23.
//

import SwiftUI
import CoreData


enum SidebarMenuSelections: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case edit
    case track
    case stats
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // https://www.youtube.com/watch?v=8buuKon6ZdQ
    @State var visibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedMenuItem: SidebarMenuSelections = .edit
    
    var blueprints: [HabitBlueprint] = [
        HabitBlueprint(name: "Work Out", description: "Lift", color: .blue, importance: 9, mode: .fullCompletion, offsetCoordinate: .init(row: 0, col: 1)),
        HabitBlueprint(name: "Drink Water", description: "3 Liters", color: .red, importance: 5, mode: .partialCompletion, offsetCoordinate: .init(row: 1, col: 0))
    ]
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
                    EditHabitsView(habitBlueprints: blueprints)
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
                case .stats:
                    Text("Stats View")
                }
            }
            
        }
    }
    

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


