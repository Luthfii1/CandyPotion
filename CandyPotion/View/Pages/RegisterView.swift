//
//  RegisterView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 19/06/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var gender = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Text("Let me know you")

        VStack {
            TextField("Name", text: $name)
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            TextField("Gender", text: $gender)
        }.padding(.horizontal)

        Button {
            submitFeedback()
            print("HELLO")
        } label: {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .frame(height: 46)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
                Text("Register").foregroundStyle(.white)
            }
        }

        HStack {
            Text("Already have an account?")
            Button(action: {}, label: {
                Text("Log In")
            })
        }
    }

    func submitFeedback() {
        guard !name.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            print("ERROR")
            return
        }

        let feedbackData = Feedback(name: name, email: email, password: password, gender: gender)
        postFeedback(feedback: feedbackData)
    }

    func postFeedback(feedback: Feedback) {
        guard let url = URL(string: "http://localhost:8000/auth/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                        self.showAlert = true
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.alertMessage = "Feedback sent successfully!"
                    self.showAlert = true
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Failed to encode feedback"
                self.showAlert = true
            }
        }
    }
}

struct Feedback: Codable {
    var name: String
    var email: String
    var password: String
    var gender: String
}

#Preview {
    RegisterView()
}
