//
//  DummyView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 26/06/24.
//

import SwiftUI

struct DummyView: View {
    var body: some View {
        VStack {
            Text("Logs")
                .font(.title)
                .foregroundColor(.blue)
                .padding()
                .background(
                    RoundedCorner(radius: 25, corners: [.topLeft, .topRight])
                        .fill(Color(red: 0.88, green: 0.63, blue: 0.33))
                        .overlay(
                            RoundedCorner(radius: 25, corners: [.topLeft, .topRight])
                                .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                        ).frame(width: 200)
                )
        }
        .padding()
    }
}

// Custom Shape for Rounded Corner
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DummyView()
    }
}

