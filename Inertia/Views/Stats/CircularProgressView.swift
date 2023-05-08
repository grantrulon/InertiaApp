//
//  CircularProgressView.swift
//  Inertia
//
//  Created by Grant Rulon on 5/7/23.
//

import SwiftUI

// https://sarunw.com/posts/swiftui-circular-progress-bar/

struct CircularProgressView: View {
    var data: Record?
    
    var body: some View {
        ZStack {
            if let data {
                Text("\(data.numberComplete) / \(data.numberTotal) Complete")
                Circle()
                    .stroke(
                        Color.blue.opacity(0.5),
                        lineWidth: 30
                    )
                let proportion: Double = Double(data.numberComplete) / Double(data.numberTotal)
                Circle()
                    .trim(from: 1 - proportion, to: 1)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
            } else {
                Text("No Data")
                Circle()
                    .stroke(
                        Color.gray.opacity(0.5),
                        lineWidth: 30
                    )
            }
            
        }
        .frame(width: 200, height: 200)
    }
}

//struct CircularProgressView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircularProgressView()
//    }
//}
