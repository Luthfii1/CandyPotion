//
//  RegisterVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 24/06/24.
//

import Foundation

class RegisterVM: ObservableObject {
    @Published var input: InputRegister
    @Published var condition: Conditions
    
    init() {
        self.input = InputRegister()
        self.condition = Conditions()
    }
    
    func submitFeedback() {
        guard !input.name.isEmpty else {
            condition.alertMessage = "Please fill the name"
            condition.showAlert = true
            return
        }
        
        guard !input.email.isEmpty else {
            condition.alertMessage = "Please fill the email"
            condition.showAlert = true
            return
        }
        
        guard !input.password.isEmpty else {
            condition.alertMessage = "Please fill the password"
            condition.showAlert = true
            return
        }
        
        postFeedback(feedback: input)
    }
    
    func postFeedback(feedback: InputRegister) {
        guard let url = URL(string: "\(APITest)/auth/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData
            
            DispatchQueue.main.async {
                self.condition.isLoading = true
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    self.condition.isLoading = false
                }
                
                if let error = error {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        print("no data received")
                        self.condition.alertMessage = "No data received"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                // Do catch for get result from json to class
                do {
                    let decodedResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    // check if succes or not with check the value of result
                    DispatchQueue.main.async {
                        if (decodedResponse.result != nil) {
                            self.input.email = ""
                            self.input.password = ""
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                            self.condition.isFinished = true
//                            self.condition.isFinished.toggle() 
                        } else {
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                        }
                    }
                } catch {
                    // catch kalo error pas lagi decode from json to
                    DispatchQueue.main.async {
                        print("Error decoding response registerVM: \(error.localizedDescription)")
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
}
