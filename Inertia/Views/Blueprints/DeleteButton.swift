//
//  DeleteButton.swift
//  Inertia
//
//  Created by Grant Rulon on 4/17/23.
//

import SwiftUI
import FirebaseFirestore

struct DeleteButton: View {
    var name: String
    var key: String
    
    @ObservedObject var inertiaViewModel: InertiaViewModel
    
    var body: some View {
        if inertiaViewModel.editMode {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        inertiaViewModel.deleteBlueprint(name: name, key: key)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
            }
        }
    }
    
    
}

//struct DeleteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteButton()
//    }
//}
