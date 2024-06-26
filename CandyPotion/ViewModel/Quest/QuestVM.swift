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
    @Published var endDate: EndDate = EndDate()
    @Published var task: TaskDescription = TaskDescription()
    @Published var timeRemaining: TimeRemaining = TimeRemaining()
    @Published var checkedState: CheckedState = CheckedState()
    @Published var reqQuest: reqLog
    @Published var accountVM: GetAccountVM = GetAccountVM()
    
    private var dailyTimer: Timer?
    private var weeklyTimer: Timer?
    
    var bgImages = [
        "Main Menu",   // Default image (dayCounter == 0)
        "Main Menu 1", // Image for dayCounter == 1
        "Main Menu 2", // Image for dayCounter == 2
        "Main Menu 3", // Image for dayCounter == 3
        "Main Menu 4", // Image for dayCounter == 4
        "Main Menu 5", // Image for dayCounter == 5
        "Main Menu 6", // Image for dayCounter == 6
        "Main Menu 7"  // Image for dayCounter == 7
    ]
    
    let personQuests: [LOVELANGUAGE: [String]] = [
        .WORDS_OF_AFFIRMATION: [
            "Write a heartfelt love letter to your partner.",
            "Bilang arigatoou senpai ke dia.",
            "Puji baju dia hari ini.",
            // Add other quests here...
        ],
        .ACTS_OF_SERVICE: [
            "Cook your partner's favorite meal.",
            "Beliin spotify premium.",
            "Kasih playlist seru.",
            // Add other quests here...
        ],
        .RECEIVING_GIFTS: [
            "Give your partner a thoughtful gift just because.",
            "Kasih voucher Sociolla.",
            "Checkoutin shopeenya.",
            // Add other quests here...
        ],
        .QUALITY_TIME: [
            "Plan a weekend getaway.",
            "Telpon 10 menit.",
            "Video Call 10 menit.",
            // Add other quests here...
        ],
        .PHYSICAL_TOUCH: [
            "Give your partner a massage.",
            "Ucapkan betapa ingin memeluknya.",
            "Beri rencana untuk berpegangan tangan nanti.",
            // Add other quests here...
        ]
    ]
    
    struct EndDate {
        var daily: Date = Date()
        var weekly: Date = Date()
    }
    
    struct TimeRemaining {
        var daily: String = ""
        var weekly: String = ""
    }
    
    struct CheckedState {
        var daily: Bool = false
        var weekly: Bool = false
    }
    
    init() {
        self.condition = Conditions()
        self.questType = QuestType.daily
        self.reqQuest = reqLog(month: 6, year: 2024)
        
        // Set initial end dates
        self.endDate.daily = Date().addingTimeInterval(60 * 60) // One hour from now
        self.endDate.weekly = Date().addingTimeInterval(60 * 60 * 24 * 7) // One week from now
        
        startTimers()
    }
    
    deinit {
        dailyTimer?.invalidate()
        weeklyTimer?.invalidate()
    }
    
    func getTimeRemaining(isDaily: Bool) -> String {
        let timeRemaining = isDaily ? self.timeRemaining.daily : self.timeRemaining.weekly
        return isCompleted(isDaily: isDaily) ? "Done" : timeRemaining
    }
    
    func isCompleted(isDaily: Bool) -> Bool {
        return isDaily ? checkedState.daily : checkedState.weekly
    }
    
    func getImage(isDaily: Bool, isLogo: Bool) -> String {
        if isLogo {
            return isDaily ? "Candy Image Quest" : "Elephant Image Quest"
        }
        return isCompleted(isDaily: isDaily) ? "Check Done" : "Check"
    }
    
    func updateQuest(isCompleted: Bool, questType: QuestType) {
        if questType == .daily {
            self.checkedState.daily = true
            self.weeklyStreak += 1
        } else {
            self.checkedState.weekly = true
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
        
        let endDate = isDaily ? endDate.daily : endDate.weekly
        
        let timeInterval = Int(endDate.timeIntervalSince(now))
        
        var timeRemainingString = ""
        
        if timeInterval <= 0 {
            timeRemainingString = "Expired"
        } else {
            let days = timeInterval / (60 * 60 * 24)
            let hours = (timeInterval % (60 * 60 * 24)) / (60 * 60)
            let minutes = (timeInterval % (60 * 60)) / 60
            let seconds = timeInterval % 60
            
            if days > 0 {
                timeRemainingString = String(format: "%d days left", days)
            } else if hours > 0 {
                timeRemainingString = String(format: "%dh %dm left", hours, minutes)
            } else if minutes > 0 {
                timeRemainingString = String(format: "%dm %ds left", minutes, seconds)
            } else {
                timeRemainingString = String(format: "%ds left", seconds)
            }
        }
        
        if isDaily {
            self.timeRemaining.daily = timeRemainingString
        } else {
            self.timeRemaining.weekly = timeRemainingString
        }
    }
    
    func getAllQuestByMonth(feedback: reqLog) {
        print("feedback: ", feedback)
        
        guard let url = URL(string: "http://localhost:8000/log/getAllQuestsByMonth/6675010198feecc0c9ed4b19") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Change to POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.main.async {
            self.condition.isLoading = true
        }
        
        do {
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
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
                            print(result)
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
    
    func getRandomQuest(loveLang: LOVELANGUAGE) {
        print("random : \(loveLang)")
        
        if let quests = personQuests[loveLang], !quests.isEmpty {
            let randomIndex = Int.random(in: 0..<quests.count)
            let selectedQuest = quests[randomIndex]
            
            self.task.daily = selectedQuest
        } else {
            self.task.daily = "No quests available for your partner's love language."
        }
        
        print("daily: \(self.task.daily)")
    }
    
    func task(for questType: QuestType) -> String {
        let isUnknown = GetAccountVM().partner.loveLanguage == .UNKNOWN
            switch questType {
            case .daily:
                if isUnknown {
                    return "Your partner haven't choose love language."
                }
                return task.daily != "" ? task.daily : "Fetching the data"
            case .weekly:
//                return task.weekly
                return "Jalan jalan ke Dufan dan puji saat pertama kali bertemu"
            }
        }
}

enum QuestType: CaseIterable {
    case daily
    case weekly
}

struct QuestUpdate: Codable {
    let isCompleted: Bool
}

class TaskDescription {
    @Published var daily: String = ""
    @Published var weekly: String = ""
}
