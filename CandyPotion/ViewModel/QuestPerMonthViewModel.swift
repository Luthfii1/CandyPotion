//
//  QuestPerMonthViewModel.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 26/06/24.
//

import Foundation

class QuestPerMonthViewModel: ObservableObject {
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

struct LogResponse: Decodable {
    let message: String
    let result: [Log]?
}

class Log: ObservableObject, Codable, Identifiable {
    @Published var _id: String
    @Published var assignUser: [String]
    @Published var isCompleted: Bool
    @Published var type: String
    @Published var description: String
    @Published var dateQuest: String
    @Published var __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, assignUser, isCompleted, type, description, dateQuest, __v
    }
    
    init(_id: String = "", assignUser: [String] = [], isCompleted: Bool = false, type: String = "DAILY", description: String = "", dateQuest: String = "", __v: Int = 0) {
        self._id = _id
        self.assignUser = assignUser
        self.isCompleted = isCompleted
        self.type = type
        self.description = description
        self.dateQuest = dateQuest
        self.__v = __v
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        assignUser = try container.decode([String].self, forKey: .assignUser)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decode(String.self, forKey: .description)
        dateQuest = try container.decode(String.self, forKey: .dateQuest)
        __v = try container.decode(Int.self, forKey: .__v)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(assignUser, forKey: .assignUser)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(type, forKey: .type)
        try container.encode(description, forKey: .description)
        try container.encode(dateQuest, forKey: .dateQuest)
        try container.encode(__v, forKey: .__v)
    }
}
