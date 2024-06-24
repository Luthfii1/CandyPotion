//
//  LoginVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 23/06/24.
//

import Foundation

class LoginVM: ObservableObject {
    @Published var person: Person
    @Published var email: String
    @Published var password: String
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var token: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    
    init() {
        self.person = Person()
        self.email = ""
        self.password = ""
    }
    
    func login() {
        let inputData = InputLogin(email: email, password: password)
        
        guard let url = URL(string: "\(APITest)/auth/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(inputData)
            request.httpBody = jsonData
            
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        print("Failed to send feedback: \(error.localizedDescription)")
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        print("no data received")
                        self.alertMessage = "No data received"
                        self.showAlert = true
                    }
                    return
                }
                
                // Do catch for get result from json to class
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    // check if succes or not with check the value of result
                    DispatchQueue.main.async {
                        if let token = decodedResponse.result {
                            self.token = token
                            UserDefaults.standard.set(self.token, forKey: "token")
                            self.alertMessage = decodedResponse.message
                            self.showAlert = true
                            self.isLoggedIn = true
                        } else {
                            self.alertMessage = decodedResponse.message
                            self.showAlert = true
                        }
                    }
                } catch {
                    // catch kalo error pas lagi decode from json to
                    DispatchQueue.main.async {
                        print("Error decoding response: \(error.localizedDescription)")
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