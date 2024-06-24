//
//  LoveLanguageModel.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 20/06/24.

import Foundation

//Beberapa questnya masih blm sesuai karena ga dilakuin secara online
class QuestViewModel: ObservableObject {
    @Published var quests: [QuestPartner] = []
    @Published var loveLanguage: LoveLanguageModel = .actsOfService
    
    init() {
//        fetchQuests()C
    }
    
    func fetchQuests() {
        guard let url = URL(string: "https://mc2-be.vercel.app/log/getValidatingQuest/6674ef2d9c4cd0231d9ace69") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching quests: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(QuestPartnerResponse.self, from: data)
                DispatchQueue.main.async {
                    self.quests = decodedResponse.result
                }
            } catch {
                print("Error decoding response fetch quest: \(error)")
            }
        }.resume()
    }
    
    private let personQuests: [LoveLanguageModel: [String]] = [
        .wordsOfAffirmation: [
            "Write a heartfelt love letter to your partner bro.",
            // Add other quests here...
        ],
        .actsOfService: [
            "Cook your partner's favorite meal.",
            // Add other quests here...
        ],
        .receivingGifts: [
            "Give your partner a thoughtful gift just because.",
            // Add other quests here...
        ],
        .qualityTime: [
            "Plan a weekend getaway.",
            // Add other quests here...
        ],
        .physicalTouch: [
            "Give your partner a massage.",
            // Add other quests here...
        ]
    ]
    
    func getRandomQuest(for loveLanguage: LoveLanguageModel) -> String {
        personQuests[loveLanguage]?.randomElement() ?? "Have a wonderful day!"
    }
}

struct QuestPartnerResponse: Decodable {
    let messages: String
    let result: [QuestPartner]
}

struct QuestPartner: Decodable, Identifiable {
    let _id: String
    let assignUser: [String]
    let isCompleted: Bool
    let type: String
    let description: String
    let dateQuest: String
    
    var id: String {
        _id
    }
}
