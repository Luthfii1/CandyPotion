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
    @StateObject private var getAccountVM = GetAccountVM()
    @StateObject private var inputCodeVM = InputCodeVM()
    @StateObject private var inputLoveLangVM = InputLoveLanguageVM()
    @AppStorage("email") var email: String?
    @AppStorage("token") var token: String?
    @AppStorage("partnerID") var partnerID: String?
    @AppStorage("loveLanguage") var loveLanguage: String?

    var body: some Scene {
        WindowGroup {
            if token == nil {
                AssessView()
//                LoginView()
//                    .environmentObject(loginVM)
            } else if partnerID == nil {
                InputCodeView()
                    .environmentObject(inputCodeVM)
            } else if loveLanguage == nil {
                InputLoveLanguage()
                    .environmentObject(inputLoveLangVM)
            } else {
                MainView()
                    .environmentObject(getAccountVM)
            }
        }
    }
}
