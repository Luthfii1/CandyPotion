//
//  QuestPerMonthViewModeol.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 26/06/24.
//

import Foundation

class QuestPerMonthVM: ObservableObject {
    var month: Int
    var year: Int
    @Published var condition = Conditions()
    @Published var questList: [Log]
    
    init(month: Int, year: Int, condition: Conditions = Conditions(), questList: [Log] = [Log()]) {
        self.month = month
        self.year = year
        self.condition = condition
        self.questList = questList
    }

    func getAllQuestByMonth() {
        guard let url = URL(string: "http://mc2-be.vercel.app/log/getAllQuestsByMonth/6675010198feecc0c9ed4b19") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Change to POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        DispatchQueue.main.async {
            self.condition.isLoading = true
        }
        
        let feedback = Request(month: month, year: year)
            
        do {
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData
                
            URLSession.shared.dataTask(with: request) { data, _, error in
                DispatchQueue.main.async {
                    self.condition.isLoading = false
                }
                    
                if let error = error {
                    DispatchQueue.main.async {
                        print("\(error.localizedDescription)")
                        self.condition.alertMessage = "Failed to send feedback questVM: \(error.localizedDescription)"
                        self.condition.showAlert = true
                    }
                    return
                }
                    
                guard let data = data else {
                    DispatchQueue.main.async {
                        print("No data received")
                        self.condition.alertMessage = "No data received"
                        self.condition.showAlert = true
                    }
                    return
                }
                    
                // Do catch for get result from json to class
                do {
                    let decodedResponse = try JSONDecoder().decode(LogResponse.self, from: data)
                    // Check if success or not by checking the value of result
                    DispatchQueue.main.async {
                        if let result = decodedResponse.result {
                            self.questList = result
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                            self.condition.isFinished = true
                        } else {
                            self.condition.alertMessage = decodedResponse.message
                            self.condition.showAlert = true
                        }
                    }
                } catch {
                    // Catch error while decoding from json to LogResponse
                    DispatchQueue.main.async {
                        print("Error decoding response: \(error.localizedDescription)")
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

struct Request: Codable {
    var month: Int
    var year: Int
}

