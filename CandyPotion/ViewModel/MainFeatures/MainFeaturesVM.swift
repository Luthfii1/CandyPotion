//
//  MainFeaturesVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 25/06/24.
//

import Foundation

class MainFeaturesVM: ObservableObject {
    @Published var person: PersonModel
    @Published var condition: Conditions
    @Published var showTodayQuest = false
    @Published var questCounter = 0
    // =================================
    @Published var selectedQuest: String = ""
    @Published var selectedQuestId: String = ""
    // Array untuk menyimpan nama gambar berdasarkan dayCounter
    let images = [
        "Main Menu",   // Default image (dayCounter == 0)
        "Main Menu 1", // Image for dayCounter == 1
        "Main Menu 2", // Image for dayCounter == 2
        "Main Menu 3", // Image for dayCounter == 3
        "Main Menu 4", // Image for dayCounter == 4
        "Main Menu 5", // Image for dayCounter == 5
        "Main Menu 6", // Image for dayCounter == 6
        "Main Menu 7"  // Image for dayCounter == 7
    ]
    
    init() {
        self.person = PersonModel()
        self.condition = Conditions()
    }
    
    func postQuest(description: String) {
        guard let url = URL(string: "") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let feedback = QuestFeedback(type: "DAILY", description: description)
        
        do {
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData
            print("jsondata: ", jsonData)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                guard let data = data else {
                    print("no data received")
                    return
                }
                
                print("data: ", data)
                
                do {
                    let decodedResponse = try JSONDecoder().decode(QuestResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.selectedQuestId = decodedResponse.result._id
                        self.condition.alertMessage = "Feedback sent successfully! Quest ID: \(decodedResponse.result._id)"
                        self.condition.showAlert = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "Error decoding response: \(error)"
                        print("Error questview: ", error)
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
    
    @MainActor func getAccount() {
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
    
    func logout() {
        print("Logout")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "partnerID")
        UserDefaults.standard.removeObject(forKey: "invitationCode")
        UserDefaults.standard.removeObject(forKey: "loveLanguage")
        UserDefaults.standard.removeObject(forKey: "email")
    }
}
