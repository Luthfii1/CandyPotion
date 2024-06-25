//
//  InputCodeVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 24/06/24.
//

import Foundation

class InputCodeVM: ObservableObject {
    @Published var condition: Conditions
    @Published var code: [String] = ["", "", "", ""]
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var idUser: String {
        UserDefaults.standard.string(forKey: "_id")!
    }
    
    init() {
        self.condition = Conditions()
    }
    
    func verifyCode() {
        // check the code is filled
        guard code.allSatisfy({ !$0.isEmpty }) else {
            condition.alertMessage = "Please enter the complete verification code"
            condition.showAlert = true
            return
        }
        
        // join into string for all codes and convert to uppercase
        let enteredCode = code.map{ $0.uppercased() }.joined()
        let inputCode = CodeRequest(inputCode: enteredCode)
        print("inputcode: ", inputCode)
        
        // API request, set header, and set method
        guard let url = URL(string: "\(APITest)/account/updateAccount/\(idUser)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // parsing from struct to json
        do {
            let jsonData = try JSONEncoder().encode(inputCode)
            request.httpBody = jsonData
            // set isLoading to give user information still fetching data from back end
            DispatchQueue.main.async {
                self.condition.isLoading = true
            }
            
            // Start session
            URLSession.shared.dataTask(with: request) { data, response, error in
                // If got error
                if let error = error {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                // check the data is received
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "No data received"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                // decode the data from json to struct or class
                do {
                    let decodedResponse = try JSONDecoder().decode(CodeResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        // check if got result
                        if let result = decodedResponse.result {
                            print("result inputCodeVM: ", result)
                        } else {
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                        }
                        self.condition.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
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
    
    func getAccount() {
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

struct CodeRequest: Codable {
    var inputCode: String
}

struct CodeResponse: Decodable {
    var message: String
    var result: PersonModel? // Succeed only
}
