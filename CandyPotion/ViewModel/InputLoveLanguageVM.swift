//
//  InputLoveLanguage.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 24/06/24.
//

import Foundation

class InputLoveLanguageVM: ObservableObject {
    @Published var person: PersonModel
    @Published var condition: Conditions
    @Published var selectedLovLang: LOVELANGUAGE

    var idUser: String {
        UserDefaults.standard.string(forKey: "_id")!
    }
    
    var token: String {
        UserDefaults.standard.string(forKey: "token")!
    }
    
    init() {
        self.person = PersonModel()
        self.condition = Conditions()
        self.selectedLovLang = .UNKNOWN
    }
    
    func updateLoveLanguage() {
        let lovelangreq = LoveLangRequest(loveLanguage: selectedLovLang.rawValue)

        // Connect to API, Set method and headers
        guard let url = URL(string: "\(APITest)/account/updateAccount/\(idUser)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Start parsing into json
        do {
            let jsonData = try JSONEncoder().encode(lovelangreq)
            request.httpBody = jsonData

            // Create session
            URLSession.shared.dataTask(with: request) { data, _, error in
                // if error
                if let error = error {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                    return
                }

                // if data empty
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "No data received"
                        self.condition.showAlert = true
                    }
                    return
                }

                // get response
                do {
                    // decode into struct or class
                    let decodedResponse = try JSONDecoder().decode(CodeResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        // check if got result
                        if let result = decodedResponse.result {
                            print("lovelang: ", result.loveLanguage?.rawValue ?? "no lovelang")
                            UserDefaults.standard.set(result.loveLanguage?.rawValue, forKey: "loveLanguage")
                        } else {
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                        }
                        self.condition.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("err lovelang: ", error.localizedDescription)
                        self.condition.alertMessage = "Error decoding response: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.condition.alertMessage = "Failed to encode feedback: \(error.localizedDescription)"
                self.condition.showAlert = true
            }
        }
    }
}

struct LoveLangRequest: Codable {
    var loveLanguage: String
}
