//
//  CandyPotionApp.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 16/06/24.
//

import SwiftUI

@main
struct CandyPotionApp: App {
    @AppStorage("email") var email: String?

    var body: some Scene {
        WindowGroup {
            if email == nil {
                LoginView()
            } else {
                MainView(email: email ?? "")
            }
        }
    }
}
