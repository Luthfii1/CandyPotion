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
        fetchQuests()
    }
    
    func fetchQuests() {
        guard let url = URL(string: "https://mc2-be.vercel.app/log/getValidatingQuest/667500d398feecc0c9ed4b13") else { return }
        
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
            "Write a heartfelt love letter to your partner.",
            "Compliment your partner on their appearance.",
            "Send an unexpected 'I love you' text message.",
            "Praise your partner in front of others.",
            "Leave a sticky note with a sweet message on the bathroom mirror.",
            "Tell your partner three things you love about them.",
            "Express gratitude for something your partner did.",
            "Write a poem for your partner.",
            "Record a voice message telling your partner how much they mean to you.",
            "Say 'thank you' and appreciate your partner for a small gesture."
        ],
        .actsOfService: [
            "Cook your partner's favorite meal.",
            "Do your partner's household chore for the day.",
            "Run an errand for your partner.",
            "Make your partner breakfast in bed.",
            "Give your partner a massage.",
            "Help your partner with a project or task they have been working on.",
            "Surprise your partner by cleaning the house.",
            "Prepare a relaxing bath for your partner.",
            "Fix something around the house that your partner has been wanting done.",
            "Pack your partner's lunch for work."
        ],
        .receivingGifts: [
            "Give your partner a thoughtful gift just because.",
            "Surprise your partner with their favorite snack.",
            "Buy your partner a book you think they would love.",
            "Create a personalized playlist for your partner.",
            "Bring home flowers for your partner.",
            "Give your partner a framed photo of a special moment you shared.",
            "Gift your partner a piece of jewelry that reminds you of them.",
            "Surprise your partner with tickets to a show or event they want to attend.",
            "Buy your partner a small item they've mentioned wanting.",
            "Craft a handmade gift for your partner."
        ],
        .qualityTime: [
            "Plan a weekend getaway.",
            "Have a movie night with your partner's favorite films.",
            "Go for a long walk together.",
            "Spend an evening stargazing.",
            "Cook a meal together.",
            "Attend a class or workshop together.",
            "Play a board game or do a puzzle together.",
            "Go on a picnic.",
            "Spend an afternoon exploring a new part of town.",
            "Have a no-phone day and focus entirely on each other."
        ],
        .physicalTouch: [
            "Give your partner a massage.",
            "Hold hands while walking.",
            "Cuddle on the couch while watching a movie.",
            "Give your partner a long hug.",
            "Dance together in your living room.",
            "Run your fingers through your partner's hair.",
            "Sit close to each other while talking.",
            "Give your partner a gentle back rub.",
            "Touch your partner's arm or shoulder when you pass by.",
            "Kiss your partner on the forehead."
        ]
    ]
    
    private let coupleQuests: [LoveLanguageModel: [String]] = [
        .wordsOfAffirmation: [
            "Exchange heartfelt love letters with each other.",
            "Compliment each other on your appearance.",
            "Send each other unexpected 'I love you' text messages throughout the day.",
            "Praise each other in front of friends or family.",
            "Leave sticky notes with sweet messages for each other around the house.",
            "Tell each other three things you love about one another.",
            "Express gratitude for something each other did.",
            "Write poems for each other.",
            "Record voice messages telling each other how much you mean to one another.",
            "Say 'thank you' and appreciate each other for small gestures."
        ],
        .actsOfService: [
            "Cook each other's favorite meal together.",
            "Help each other with household chores.",
            "Run errands together for each other.",
            "Make breakfast in bed for each other on alternate days.",
            "Give each other massages.",
            "Help each other with projects or tasks.",
            "Surprise each other by cleaning the house together.",
            "Prepare a relaxing bath for each other.",
            "Fix something around the house together.",
            "Pack lunch for each other for work."
        ],
        .receivingGifts: [
            "Give each other thoughtful gifts just because.",
            "Surprise each other with your favorite snacks.",
            "Buy each other books that you think the other would love.",
            "Create personalized playlists for each other.",
            "Bring home flowers for each other.",
            "Give each other framed photos of special moments you shared.",
            "Gift each other pieces of jewelry that remind you of one another.",
            "Surprise each other with tickets to a show or event you both want to attend.",
            "Buy small items for each other that you've mentioned wanting.",
            "Craft handmade gifts for each other."
        ],
        .qualityTime: [
            "Plan a weekend getaway together.",
            "Have a movie night with each other's favorite films.",
            "Go for a long walk together.",
            "Spend an evening stargazing together.",
            "Cook meals together.",
            "Attend classes or workshops together.",
            "Play board games or do puzzles together.",
            "Go on a picnic together.",
            "Spend an afternoon exploring a new part of town together.",
            "Have a no-phone day and focus entirely on each other."
        ],
        .physicalTouch: [
            "Hold hands together when going for a walk.",
            "Cuddle on the couch while watching a movie together.",
            "Give each other long hugs.",
            "Dance together in your living room.",
            "Run your fingers through each other's hair.",
            "Sit close to each other while talking.",
            "Give each other gentle back rubs.",
            "Touch each other's arms or shoulders when passing by.",
            "Kiss each other on the forehead.",
            "Give each other foot massages."
        ]
    ]


    
    func getRandomPersonQuest(for loveLanguage: LoveLanguageModel) -> String {
        personQuests[loveLanguage]?.randomElement() ?? "Have a wonderful day!"
    }
    
    func getRandomCoupleQuest(for loveLanguage: LoveLanguageModel) -> String {
        coupleQuests[loveLanguage]?.randomElement() ?? "Have a wonderful day!"
    }
}

struct QuestPartnerResponse: Decodable {
    let message: String
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
