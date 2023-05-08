//
//  WeekdaysPickerView.swift
//  Inertia
//
//  Created by Grant Rulon on 5/5/23.
//

import SwiftUI

struct WeekdaysPickerView: View {
    
    @Binding var monday: Bool
    @Binding var tuesday: Bool
    @Binding var wednesday: Bool
    @Binding var thursday: Bool
    @Binding var friday: Bool
    @Binding var saturday: Bool
    @Binding var sunday: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                monday.toggle()
            }, label: {
                Text("M")
                    .foregroundColor(monday ? .white : .white.opacity(0.5))
            })
            Button(action: {
                tuesday.toggle()
            }, label: {
                Text("T")
                    .foregroundColor(tuesday ? .white : .white.opacity(0.5))
            })
            Button(action: {
                wednesday.toggle()
            }, label: {
                Text("W")
                    .foregroundColor(wednesday ? .white : .white.opacity(0.5))
            })
            Button(action: {
                thursday.toggle()
            }, label: {
                Text("T")
                    .foregroundColor(thursday ? .white : .white.opacity(0.5))
            })
            Button(action: {
                friday.toggle()
            }, label: {
                Text("F")
                    .foregroundColor(friday ? .white : .white.opacity(0.5))
            })
            Button(action: {
                saturday.toggle()
            }, label: {
                Text("S")
                    .foregroundColor(saturday ? .white : .white.opacity(0.5))
            })
            Button(action: {
                sunday.toggle()
            }, label: {
                Text("S")
                    .foregroundColor(sunday ? .white : .white.opacity(0.5))
            })
        }
        .buttonStyle(.plain)
    }
}

//struct WeekdaysPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekdaysPickerView()
//    }
//}
