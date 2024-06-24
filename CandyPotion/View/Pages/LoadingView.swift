//
//  LoadingView.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 24/06/24.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject private var getAccount : GetAccountVM
    
    var body: some View {
        ZStack{
            Color(.purpleCandy).ignoresSafeArea()
            Image("background").resizable().opacity(0.5).ignoresSafeArea()
            
            VStack {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2)
                    .padding(.top, 20)
                
                Text("Please wait")
                    .padding(.top, 30)
            }
            .padding(20)
            .background(.white)
            .cornerRadius(25)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
}

#Preview {
    LoadingView()
        .environmentObject(GetAccountVM())
}
