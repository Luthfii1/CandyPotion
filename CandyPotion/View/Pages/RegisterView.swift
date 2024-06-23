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
        NavigationStack {
            ZStack {
                Color(.purpleCandy).ignoresSafeArea()
                Image("background").resizable().opacity(0.5).ignoresSafeArea()

                VStack {
                    Text("Let us know you!")
                        .font(
                            Font.custom("Mali-Bold", size: 32)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                            HStack {
                                TextField("Name", text: $name)
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
                                TextField("Password", text: $password).autocapitalization(.none)
                                    .font(.custom("Mali-Regular", size: 18))
                                    .padding(.horizontal)
                            }
                            .frame(width: 329)
                        }

                        Spacer().frame(height: 12)

                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                            HStack {
                                TextField("Gender", text: $gender)
                                    .font(.custom("Mali-Regular", size: 18))
                                    .padding(.horizontal)
                            }
                            .frame(width: 329)
                        }
                    }

                    Spacer().frame(height: 72)

                    
                    Button {
                        submitFeedback()
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 329, height: 51)
                                .background(Color(red: 0.56, green: 0.4, blue: 0.78))
                                .cornerRadius(12)
                            Text("Sign Up")
                                .font(
                                    Font.custom("Mali", size: 24)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                    }

                    
                    HStack {
                        Text("Already have an account?").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.81))
                        NavigationLink(destination: LoginView()) {
                            Text("Log In").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                                .foregroundColor(.white).underline()
                        }
                    }
                }
            }

        }.navigationBarBackButtonHidden()
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
        guard let url = URL(string: "http://mc2-be.vercel.app/auth/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { _, response, error in
                print("HELLO3")

                if let error = error {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    print("HELLO2")

                    DispatchQueue.main.async {
                        self.alertMessage = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                        print(response)
                        self.showAlert = true
                    }
                    return
                }

                DispatchQueue.main.async {
                    print("HELLO")

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
