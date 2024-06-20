//
//  MainView.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 17/06/24.
//

import SwiftUI

struct MainView: View {
    @State var email: String
    var body: some View {
        Text("Hello, \(email)! This is main page!")
    }
}

#Preview {
    MainView(email: "AL")
}
