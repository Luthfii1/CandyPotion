//
//  MainView.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 17/06/24.
//

import SwiftUI

struct MainView: View {
    @State var email: String
    @State private var showTodayQuest = false // State variable to control the sheet presentation
    
    var body: some View {
        ZStack {
            Image("Main Menu")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Spacer()
            }
        }
        .sheet(isPresented: $showTodayQuest) {
            TodayQuestView()
                .presentationDetents([.fraction(0.25), .medium, .large])
        }
        .onAppear {
            showTodayQuest = true
        }
    }
}

struct TodayQuestView: View {
    var body: some View {
        VStack {
            Text("Today's Quest")
                .font(Font.custom("Mali-Bold", size: 36))
                .padding(.top, 24)
            Spacer()
        }
    }
}

#Preview {
    MainView(email: "AL")
}
