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
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Text("Welcome Back!")
                    .padding()

                VStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                Button {
                    login()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                            .frame(height: 46)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                        Text("Log In").foregroundStyle(.white)
                    }
                }
                .padding(.top, 20)

                HStack {
                    Text("Do not have an account?")
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                    }
                }
                .padding(.top, 20)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(for: String.self) { _ in
                InputCodeView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func login() {
        guard !email.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
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

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        self.alertMessage = "No data received"
                        self.showAlert = true
                    }
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.token = decodedResponse.result

                        UserDefaults.standard.set(self.email, forKey: "email")
                        UserDefaults.standard.set(self.token, forKey: "token")

                        self.getAccount(token: self.token)

                        self.path.append("Home")
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alertMessage = "Error decoding response: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Failed to encode feedback"
                self.showAlert = true
            }
        }
    }

    func getAccount(token: String) {
        print("test")
        guard let url = URL(string: "http://localhost:8000/account/getAccount") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                DispatchQueue.main.async {}
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    print("no data received")
                }
                return
            }

            do {
                print(data)
                let decodedResponse = try JSONDecoder().decode(AccountResponse.self, from: data)
                print(decodedResponse)
            } catch {
                DispatchQueue.main.async {
                }
            }
        }.resume()
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

struct AccountResponse: Decodable {
    var _id: String?
    var name: String?
    var email: String?
    var dateCreated: String?
    var password: String?
    var partnerID: String?
    var gender: String?
    var loveLanguage: String?
    var invitationCode: String?
}

#Preview {
    LoginView()
}
