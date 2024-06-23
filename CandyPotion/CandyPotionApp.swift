//
//  CandyPotionApp.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 16/06/24.
//

import SwiftUI

@main
struct CandyPotionApp: App {
    @StateObject private var loginVM = LoginVM()
    @AppStorage("email") var email: String?
    @AppStorage("token") var token: String?
    @AppStorage("partnerID") var partnerID: String?

    var body: some Scene {
        WindowGroup {
            if token == nil {
                LoginView()
                    .environmentObject(loginVM)
            } else if partnerID == "" {
                InputCodeView()
            } else {
                MainView()
            }
        }
    }
}
