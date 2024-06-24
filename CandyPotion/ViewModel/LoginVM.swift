//
//  LoginVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 23/06/24.
//

import Foundation

class LoginVM: ObservableObject {
    @Published var person: PersonModel
    @Published var input: InputLogin
    @Published var condition: Conditions
    
    init() {
        self.person = PersonModel()
        self.input = InputLogin()
        self.condition = Conditions()
    }
    
    func login() {
        // Check input email not empty
        guard !input.email.isEmpty else {
            condition.alertMessage = "Please fill the email"
            condition.showAlert = true
            return
        }
        //Check input password not empty
        guard !input.password.isEmpty else {
            condition.alertMessage = "Please fill the password"
            condition.showAlert = true
            return
        }
        // Set API, method and headers
        guard let url = URL(string: "\(APITest)/auth/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // do catch for parsing
        do {
            // parsing data from input struct to json
            let jsonData = try JSONEncoder().encode(input)
            request.httpBody = jsonData
            // set isLoading to give user information still fetching data from back end
            DispatchQueue.main.async {
                self.condition.isLoading = true
            }
            
            // Call API sessions
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Check if there are error
                if let error = error {
                    DispatchQueue.main.async {
                        print("Failed to send feedback: \(error.localizedDescription)")
                        self.condition.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                // Check got the data or not from backend
                guard let data = data else {
                    DispatchQueue.main.async {
                        print("no data received")
                        self.condition.alertMessage = "No data received"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                // do catch for decode from json to struct or class
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                    DispatchQueue.main.async {
                        // if success got the result
                        if let token = decodedResponse.result {
                            self.input.email = ""
                            self.input.password = ""
                            UserDefaults.standard.set(token, forKey: "token")
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                            self.getAccount() // Call getAccount here
                        } else { // if got error
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                        }
                        // finish loading
                        self.condition.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error decoding response loginVM: \(error.localizedDescription)")
                        self.condition.alertMessage = "Error decoding response: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.condition.alertMessage = "Failed to encode feedback"
                self.condition.showAlert = true
            }
        }
    }
    
    private func getAccount() {
        GetAccountVM().getAccount { success in
            DispatchQueue.main.async {
                if success {
                    // TODO: WILL BE DELETE
//                    print("token login getAccount: \(UserDefaults.standard.string(forKey: "token") ?? "no token")")
//                    print("id login getAccount: \(UserDefaults.standard.string(forKey: "_id") ?? "no id")")
//                    print("invt login getAccount: \(UserDefaults.standard.string(forKey: "invitationCode") ?? "no code")")
//                    print("partnerID login getAccount: \(UserDefaults.standard.string(forKey: "partnerID") ?? "no partnerID")")
                    // Until here
                    self.condition.isFinished = true
                } else {
                    self.condition.alertMessage = "Failed to get account information."
                    self.condition.showAlert = true
                }
            }
        }
    }
}
