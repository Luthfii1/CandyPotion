//
//  QuestVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 25/06/24.
//

import Foundation

class QuestVM: ObservableObject {
    @Published var condition: Conditions
    @Published var questType: QuestType
    @Published var weeklyStreak: Int = 0
    @Published var dailyEndDate: Date = Date()
    @Published var weeklyEndDate: Date = Date()
    @Published var dailyTimeRemaining: String = ""
    @Published var weeklyTimeRemaining: String = ""
    @Published var dailyChecked: Bool = false
    @Published var weeklyChecked: Bool = false
    
    private var dailyTimer: Timer?
    private var weeklyTimer: Timer?
    
    init() {
        self.condition = Conditions()
        self.questType = QuestType.daily
        
        // Set initial end dates
        self.dailyEndDate = Date().addingTimeInterval(60 * 60) // One hour from now
        self.weeklyEndDate = Date().addingTimeInterval(60 * 60 * 24 * 7) // One week from now
        
        startTimers()
    }
    
    deinit {
        dailyTimer?.invalidate()
        weeklyTimer?.invalidate()
    }
    
    func updateQuest(isCompleted: Bool, questType: QuestType) {
        if questType == .daily {
            self.dailyChecked = true
            self.weeklyStreak += 1
        } else {
            self.weeklyChecked = true
        }
        
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
    
    func startTimers() {
        dailyTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimeRemaining(isDaily: true)
        }
        
        weeklyTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimeRemaining(isDaily: false)
        }
    }
    
    private func updateTimeRemaining(isDaily: Bool) {
        let now = Date()
        
        if isDaily {
            let dailyTimeInterval = Int(dailyEndDate.timeIntervalSince(now))
            if dailyTimeInterval <= 0 {
                dailyTimeRemaining = "Expired"
            } else {
                let days = dailyTimeInterval / (60 * 60 * 24)
                let hours = (dailyTimeInterval % (60 * 60 * 24)) / (60 * 60)
                let minutes = (dailyTimeInterval % (60 * 60)) / 60
                let seconds = dailyTimeInterval % 60
                
                if days > 0 {
                    dailyTimeRemaining = String(format: "%d days left", days)
                } else if hours > 0 {
                    dailyTimeRemaining = String(format: "%dh %dm left", hours, minutes)
                } else if minutes > 0 {
                    dailyTimeRemaining = String(format: "%dm %ds left", minutes, seconds)
                } else {
                    dailyTimeRemaining = String(format: "%ds left", seconds)
                }
            }
        } else {
            let weeklyTimeInterval = Int(weeklyEndDate.timeIntervalSince(now))
            if weeklyTimeInterval <= 0 {
                weeklyTimeRemaining = "Expired"
            } else {
                let days = weeklyTimeInterval / (60 * 60 * 24)
                let hours = (weeklyTimeInterval % (60 * 60 * 24)) / (60 * 60)
                let minutes = (weeklyTimeInterval % (60 * 60)) / 60
                let seconds = weeklyTimeInterval % 60
                
                if days > 0 {
                    weeklyTimeRemaining = String(format: "%d days left", days)
                } else if hours > 0 {
                    weeklyTimeRemaining = String(format: "%dh %dm left", hours, minutes)
                } else if minutes > 0 {
                    weeklyTimeRemaining = String(format: "%dm %ds left", minutes, seconds)
                } else {
                    weeklyTimeRemaining = String(format: "%ds left", seconds)
                }
            }
        }
    }
    
    func getTimeRemaining(isDaily: Bool) -> String {
        if isDaily {
            return dailyChecked ? "Done" : dailyTimeRemaining
        } else {
            return weeklyChecked ? "Done" : weeklyTimeRemaining
        }
    }
    
    func isCompleted(isDaily: Bool) -> Bool {
        if isDaily {
            return dailyChecked
        } else {
            return weeklyChecked
        }
    }
    
    func getButton(isDaily: Bool) -> String {
        if isDaily {
            return dailyChecked ? "Check Done" : "Check"
        } else {
            return weeklyChecked ? "Check Done" : "Check"
        }
    }
}

enum QuestType {
    case daily
    case weekly
}

struct QuestUpdate: Codable {
    let isCompleted: Bool
}
