//
//  QuestVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 25/06/24.
//

import Foundation

class QuestVM: ObservableObject {
    @Published var endDate: Date = Date().addingTimeInterval(60 * 60)
    @Published var timeRemaining: String = ""
    @Published var isChecked: Bool = false
    @Published var condition: Conditions
    @Published var questCounter: Int = 0
    @Published var dailyChecked: Bool = false
    @Published var dailyTimeRemaining: String = ""
    
    init() {
        self.condition = Conditions()
    }
    
    func startTimer() {
        updateTimeRemaining()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateTimeRemaining()
        }
    }
    
    func updateTimeRemaining() {
        let now = Date()
        let timeInterval = endDate.timeIntervalSince(now)
        if timeInterval <= 0 {
            timeRemaining = "Expired"
        } else {
            let minutes = Int(timeInterval) / 60
            let seconds = Int(timeInterval) % 60
            timeRemaining = String(format: "%02dm %02ds left", minutes, seconds)
        }
    }
    
    func updateQuest(isCompleted: Bool) {
        guard let url = URL(string: "") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let update = QuestUpdate(isCompleted: isCompleted)
        
        do {
            let jsonData = try JSONEncoder().encode(update)
            request.httpBody = jsonData
            print("jsondata: ", jsonData)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.condition.alertMessage = "Failed to update quest: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                    return
                }
                
                guard let data = data else {
                    print("no data received")
                    return
                }
                
                print("data: ", data)
                
                DispatchQueue.main.async {
                    self.condition.alertMessage = "Quest updated successfully!"
                    self.condition.showAlert = true
                    print("Success!")
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.condition.alertMessage = "Failed to encode update"
                self.condition.showAlert = true
            }
        }
    }
}


struct QuestUpdate: Codable {
    let isCompleted: Bool
}

struct Result: Decodable {
    let assignUser: [String]
    let isCompleted: Bool
    let type: String
    let description: String
    let _id: String
    let dateQuest: String
    let __v: Int
}

