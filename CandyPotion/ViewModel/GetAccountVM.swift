//
//  GetAccount.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 24/06/24.
//

import Foundation

class GetAccountVM: ObservableObject {
    @Published var person: PersonModel
    @Published var partner: PersonModel
    @Published var condition: Conditions
    
    init() {
        self.person = PersonModel()
        self.partner = PersonModel()
        self.condition = Conditions()
    }
    
    private var token: String? {
        UserDefaults.standard.string(forKey: "token")
    }
    
    @MainActor
    func getAccount(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APITest)/account/getAccount") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(false)
            return
        }
        
        DispatchQueue.main.async {
            self.condition.isLoading = true
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.condition.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("Failed to get account: \(error.localizedDescription)")
                    self.condition.alertMessage = "Failed to get account: \(error.localizedDescription)"
                    self.condition.showAlert = true
                }
                completion(false)
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received")
                    self.condition.alertMessage = "No data received"
                    self.condition.showAlert = true
                }
                completion(false)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GetAccountResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.condition.alertMessage = decodedResponse.message
                    self.condition.showAlert = true
                    
                    if let result = decodedResponse.result {
                        self.person = result
                        UserDefaults.standard.set(result.invitationCode, forKey: "invitationCode")
                        UserDefaults.standard.set(result._id, forKey: "_id")
                        
                        if let partnerID = result.partnerID {
                            UserDefaults.standard.set(partnerID, forKey: "partnerID")
                        } else {
                            print("PartnerID is nil")
//                            print(UserDefaults.standard.string(forKey: "invitationCode") ?? "no invitation code")
                        }
                        
                        if let loveLanguage = result.loveLanguage {
                            UserDefaults.standard.set(loveLanguage.rawValue, forKey: "loveLanguage")
                        } else {
                            print("lovelang is nil")
                        }
                        self.condition.isFinished = true
                        completion(true)
                    } else {
                        self.condition.alertMessage = decodedResponse.message
                        self.condition.showAlert = true
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error decoding response get account: \(error.localizedDescription)")
                    self.condition.alertMessage = "Error decoding response: \(error.localizedDescription)"
                    self.condition.showAlert = true
                }
                completion(false)
            }
        }.resume()
    }
    
    @MainActor
    func getPartner(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(APITest)/partner/\(UserDefaults.standard.string(forKey: "_id")!)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(false)
            return
        }
        
        DispatchQueue.main.async {
            self.condition.isLoading = true
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.condition.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    print("Failed to get account: \(error.localizedDescription)")
                    self.condition.alertMessage = "Failed to get account: \(error.localizedDescription)"
                    self.condition.showAlert = true
                }
                completion(false)
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received")
                    self.condition.alertMessage = "No data received"
                    self.condition.showAlert = true
                }
                completion(false)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(GetAccountResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.condition.alertMessage = decodedResponse.message
                    self.condition.showAlert = true
                    
                    if let result = decodedResponse.result {
                        self.partner = result
                        print("partner lovelange in getaccount: \(self.partner.loveLanguage ?? .UNKNOWN)")
                        self.condition.isFinished = true
                        completion(true)
                    } else {
                        self.condition.alertMessage = decodedResponse.message
                        self.condition.showAlert = true
                        completion(false)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error decoding response get account: \(error.localizedDescription)")
                    self.condition.alertMessage = "Error decoding response: \(error.localizedDescription)"
                    self.condition.showAlert = true
                }
                completion(false)
            }
        }.resume()
    }
    
    func logout() {
        print("Logout")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "partnerID")
        UserDefaults.standard.removeObject(forKey: "invitationCode")
        UserDefaults.standard.removeObject(forKey: "loveLanguage")
        UserDefaults.standard.removeObject(forKey: "email")
    }
}
