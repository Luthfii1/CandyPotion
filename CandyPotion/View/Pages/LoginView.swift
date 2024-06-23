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
    @State private var partnerID = ""
    @ObservedObject private var person = PersonModel(name: "", email: "", dateCreated: "", partnerID: "", gender: GENDER(rawValue: "UNKNOWN")!, loveLanguage: LOVELANGUAGE(rawValue: "UNKNOWN")!, invitationCode: "", _id: "")

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.purpleCandy).ignoresSafeArea()
                Image("background").resizable().opacity(0.5).ignoresSafeArea()
                
                VStack {
                    Image("loginAssets").resizable().frame(width: 257, height: 373).offset(y: 24)

                    Text("Welcome Back!")
                        .font(
                            Font.custom("Mali-Bold", size: 32)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .offset(y: -12)

                    Text("Your presence matters,\nget back into Candylabs!")
                        .font(
                            Font.custom("Mali-Regular", size: 15)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.bottom)

                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                            HStack {
                                TextField("Email", text: $email)
                                    .autocapitalization(.none)
                                    .font(.custom("Mali-Regular", size: 18))
                                    .padding(.horizontal)
                            }
                            .frame(width: 329)
                        }
                        
                        Spacer().frame(height: 12)

                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                            HStack {
                                SecureField("Password", text: $password)
                                    .autocapitalization(.none)
                                    .font(.custom("Mali-Regular", size: 18))
                                    .padding(.horizontal)
                            }
                            .frame(width: 329)
                        }
                    }

                    Spacer().frame(height: 32)

                    Button {
                        login()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 329, height: 51)
                                .background(Color(red: 0.56, green: 0.4, blue: 0.78))
                                .cornerRadius(12)
                            Text("Log in")
                                .font(
                                    Font.custom("Mali", size: 24)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                    }

                    HStack {
                        Text("Do not have an account?").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.81))

                        NavigationLink(destination: RegisterView()) {
                            Text("Register").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                                .foregroundColor(.white).underline()
                        }
                    }
                }.offset(y: -20)

                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }

//            .navigationDestination(for: String.self) { _ in
//                InputCodeView()
//            }
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
        guard let url = URL(string: "http://mc2-be.vercel.app/auth/login") else { return }
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
                        UserDefaults.standard.set(self.partnerID, forKey: "partnerID")

                        person.getAccount(token: self.token) { success in
                            if success {
                                UserDefaults.standard.setPerson(self.person, forKey: "person")
                            } else {
                                self.alertMessage = "Failed to fetch account details"
                                self.showAlert = true
                            }
                        }
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
