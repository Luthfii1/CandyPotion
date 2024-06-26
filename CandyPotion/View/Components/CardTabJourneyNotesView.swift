//
//  DummyView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 26/06/24.
//

import SwiftUI

struct CardTabJourneyNotesView: View {
    var textRectangle: String
    var isActive: Bool
    
    var body: some View {
        VStack {
            Text(textRectangle)
                .frame(width: 157)
                .font(Font.custom("Mali-Bold", size: 24))
                .foregroundColor(.white)
                .padding()
                .background(
                    RoundedCorner(radius: 25, corners: [.topLeft, .topRight])
                        .fill(isActive ? Color(red: 0.88, green: 0.63, blue: 0.33) : Color(red: 0.55, green: 0.4, blue: 0.21))
                        .overlay(
                            RoundedCorner(radius: 25, corners: [.topLeft, .topRight])
                                .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                        ).frame(width: 195)
                )
        }
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

struct CardTabJourneyNotesView_Previews: PreviewProvider {
    static var previews: some View {
        CardTabJourneyNotesView(textRectangle: "Logs", isActive: true)
    }
}

