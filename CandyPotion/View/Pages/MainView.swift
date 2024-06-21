//
//  MainView.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 17/06/24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("email") var email: String?

    var body: some View {
        VStack {
            if let savedPerson = UserDefaults.standard.person(forKey: "person") {
                Text("Hello, \(savedPerson.email)! This is the main page!")
            }

            Text("Hello, \(email ?? "")! This is the main page!")
                .padding()

            Button(action: logout) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }

    func logout() {
        email = nil
    }
}

#Preview {
    MainView()
}
