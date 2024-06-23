//
//  LoginView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 20/06/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    @State private var token = ""

    var body: some View {
        Text("Welcome Back!")

        VStack {
            TextField("Email", text: $email)
            TextField("Password", text: $password)
        }.padding(.horizontal)

        Button {
            login()
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

    func login() {
        guard !email.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            print("ERROR")
            return
        }

        let feedbackData = LoginFeedback(email: email, password: password)
        postFeedback(feedback: feedbackData)
    }

    func postFeedback(feedback: LoginFeedback) {
        guard let url = URL(string: "http://localhost:8000/auth/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData
            print("hsobdata: ", jsonData)

            URLSession.shared.dataTask(with: request) { data, _, error in

                if let error = error {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }

                guard let data = data else {
                    print("NO data received")
                    return
                }
                print("data", data)

                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.token = decodedResponse.result
                        print("Token: \(decodedResponse.result)")
                    }

                    UserDefaults.standard.set(email, forKey: "email")

                    print(UserDefaults.standard.string(forKey: "email"))
                    UserDefaults.standard.set(token, forKey: "token")
                } catch {
                    print("Error decoding response: \(error)")
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

struct LoginFeedback: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Decodable {
    let messages: String
    let result: String
}

#Preview {
    LoginView()
}
