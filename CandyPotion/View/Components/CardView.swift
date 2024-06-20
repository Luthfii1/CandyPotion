// CardView.swift
import SwiftUI

struct CardView: View {
    let quest: String
    
    var body: some View {
        VStack {
            Text(quest)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

#Preview {
    CardView(quest: "Write a heartfelt love letter to your partner.")
}
