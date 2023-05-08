//
//  ContentView.swift
//  Inertia
//
//  Created by Grant Rulon on 4/10/23.
//

import SwiftUI


enum SidebarMenuSelections: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case MyHabits = "Habits"
    case TrackTheDay = "Track"
    case stats = "Progress"
}

struct ContentView: View {
    @StateObject var inertiaViewModel = InertiaViewModel()
    
    // https://www.youtube.com/watch?v=8buuKon6ZdQ
    @State var visibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedMenuItem: SidebarMenuSelections = .MyHabits
    @State var showingProfilePopover = false
    
    var body: some View {
        HStack {
            NavigationSplitView(columnVisibility: $visibility) {
                List(SidebarMenuSelections.allCases, selection: $selectedMenuItem) { item in
                    NavigationLink(item.rawValue, value: item)
                }
            } detail: {
                switch selectedMenuItem {
                    
                case .MyHabits:
                    if inertiaViewModel.isLoggedIn {
                        EditHabitsView(habitBlueprints: $inertiaViewModel.blueprints, habits: $inertiaViewModel.todayHabits, inertiaViewModel: inertiaViewModel)
                    } else {
                        Text("Login To Begin!")
                            .font(
                                .largeTitle
                                .weight(.bold)
                            )
                            .foregroundColor(.blue)
                    }
                    
                case .TrackTheDay:
                    if inertiaViewModel.isLoggedIn {
                        VStack {
                            HabitRecordView(todayHabits: $inertiaViewModel.todayHabits, inertiaViewModel: inertiaViewModel)
                        }
                    } else {
                        Text("Login To Begin!")
                            .font(
                                .largeTitle
                                .weight(.bold)
                            )
                            .foregroundColor(.blue)
                    }
                    
                case .stats:
                    if inertiaViewModel.isLoggedIn {
                        StatsView(habits: $inertiaViewModel.habits, stats: $inertiaViewModel.stats)
                    } else {
                        Text("Login To Begin!")
                            .font(
                                .largeTitle
                                .weight(.bold)
                            )
                            .foregroundColor(.blue)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        showingProfilePopover = true
                        }, label: {
                            HStack {
                                Text(inertiaViewModel.user.email)
                                Image(systemName: "person.crop.circle").imageScale(.large)
                            }
                        }
                    )
                    .popover(isPresented: $showingProfilePopover) {
                        if inertiaViewModel.isLoggedIn {
                            LoggedInView(user: $inertiaViewModel.user, isLoggedIn: $inertiaViewModel.isLoggedIn)
                                .frame(width: 200, height: 100)
                                .padding()
                        } else {
                            AccountView(isLoggedIn: $inertiaViewModel.isLoggedIn, user: $inertiaViewModel.user)
                                .frame(width: 400, height: 400)
                                .padding()
                        }
                    }
                    
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


