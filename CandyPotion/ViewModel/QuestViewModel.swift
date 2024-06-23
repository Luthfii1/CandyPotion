//
//  LoveLanguageModel.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 20/06/24.

import Foundation

//Beberapa questnya masih blm sesuai karena ga dilakuin secara online
class QuestViewModel: ObservableObject {
    @Published var quests: [QuestPartner] = []
    @Published var loveLanguage: LoveLanguageModel = .wordsOfAffirmation
    
    init() {
        fetchQuests()
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
                print("Error decoding response: \(error)")
            }
        }.resume()
    }
    
    private let personQuests: [LoveLanguageModel: [String]] = [
        .wordsOfAffirmation: [
            "Write a heartfelt love letter to your partner.",
            "Compliment your partner's appearance today.",
            "Text your partner three things you love about them.",
            "Leave a sweet message for your partner to find.",
            "Start the day by telling your partner one reason why you love them.",
            "Share a positive memory you cherish with your partner.",
            "Write a poem expressing your feelings for your partner.",
            "Send an unexpected 'I love you' text during the day.",
            "Tell your partner how proud you are of them.",
            "Highlight and appreciate something your partner did well today.",
            "Whisper something sweet to your partner before bedtime.",
            "Write a list of ten reasons why you love your partner.",
            "Publicly praise your partner.",
            "Compliment your partner in front of friends or family.",
            "Make a personalized card with affirming words for your partner.",
            "Tell your partner one thing you appreciate about them every hour today.",
            "Record a voice message expressing your love and send it to your partner.",
            "Share a positive affirmation with your partner first thing in the morning.",
            "Acknowledge and thank your partner for something they often do.",
            "Write down a favorite quote that reminds you of your partner and share it with them.",
            "Tell your partner what makes them unique and special to you.",
            "Reflect on a challenging time and share how your partner's support helped you.",
            "Sing a love song to your partner or dedicate one to them.",
            "Tell your partner what you admire most about them.",
            "Write a love note and hide it in a place where your partner will find it.",
            "Share three things you’re grateful for in your relationship.",
            "Express how your partner has positively impacted your life.",
            "Tell your partner what you look forward to in your future together.",
            "Celebrate a small victory or accomplishment of your partner.",
            "Start a journal where you write affirmations for your partner every day and share it with them at the end of the month."
        ],
        .actsOfService: [
            "Cook your partner's favorite meal.",
            "Do a chore your partner dislikes doing.",
            "Surprise your partner with breakfast in bed.",
            "Run an errand for your partner.",
            "Plan and organize a date night.",
            "Help your partner with a project they're working on.",
            "Prepare a relaxing bath for your partner.",
            "Take care of your partner's responsibilities for a day.",
            "Do a household task without being asked.",
            "Organize a surprise outing for your partner.",
            "Fix something that's been broken for a while.",
            "Pack your partner's lunch with a sweet note inside.",
            "Wash and clean your partner's car.",
            "Arrange for a cleaning service to come to the house.",
            "Do the grocery shopping for the week.",
            "Give your partner a day off from their usual tasks.",
            "Organize your partner's workspace.",
            "Prepare a surprise picnic.",
            "Take over bedtime duties for the kids.",
            "Surprise your partner by handling a task they've been putting off.",
            "Make a list of things you can do to make your partner's day easier.",
            "Arrange a surprise home-cooked dinner.",
            "Help your partner with their to-do list.",
            "Clean the house as a surprise.",
            "Do a task your partner usually handles.",
            "Prepare a special breakfast on a weekend.",
            "Help your partner organize their closet.",
            "Take your partner's pet for a walk.",
            "Do the laundry and fold it neatly.",
            "Make your partner's favorite dessert."
        ],
        .receivingGifts: [
            "Give your partner a thoughtful gift just because.",
            "Surprise your partner with flowers.",
            "Buy your partner a book they've been wanting to read.",
            "Create a scrapbook of your favorite memories together.",
            "Surprise your partner with tickets to a show or event.",
            "Gift your partner something personalized.",
            "Make a handmade gift for your partner.",
            "Surprise your partner with their favorite snack.",
            "Write a heartfelt letter and give it as a gift.",
            "Buy your partner a small item that reminded you of them.",
            "Give your partner a gift card to their favorite store.",
            "Surprise your partner with breakfast in bed and a small gift.",
            "Create a photo album of your best moments together.",
            "Gift your partner a day of pampering.",
            "Buy your partner something they've been hinting at.",
            "Surprise your partner with a subscription service they’d enjoy.",
            "Give your partner a 'just because' gift.",
            "Buy your partner a piece of jewelry.",
            "Create a custom playlist and give it as a gift.",
            "Surprise your partner with a gadget they've been eyeing.",
            "Gift your partner a framed picture of a cherished moment.",
            "Buy your partner a special bottle of wine or their favorite drink.",
            "Surprise your partner with a new outfit.",
            "Buy your partner a plant or flowers for the home.",
            "Gift your partner a personalized mug or item they’ll use daily.",
            "Surprise your partner with a weekend getaway.",
            "Buy your partner a new piece of art for the home.",
            "Gift your partner a cooking class or workshop.",
            "Surprise your partner with a themed gift basket.",
            "Buy your partner something that supports their hobby."
        ],
        .qualityTime: [
            "Plan a weekend getaway.",
            "Spend an evening stargazing together.",
            "Have a technology-free day together.",
            "Cook a meal together and enjoy it by candlelight.",
            "Plan a game night with your favorite board games.",
            "Go for a long walk or hike together.",
            "Watch a movie or TV series marathon together.",
            "Take a day trip to a nearby town or attraction.",
            "Have a picnic in the park.",
            "Visit a museum or art gallery together.",
            "Plan a surprise date night.",
            "Take a class or workshop together.",
            "Read a book together and discuss it.",
            "Spend the day at the beach or a lake.",
            "Have a themed dinner night at home.",
            "Go for a bike ride together.",
            "Visit a local farmers market or fair.",
            "Spend the evening playing video games together.",
            "Have a backyard campout.",
            "Plan a day of activities that your partner loves.",
            "Go to a concert or live event together.",
            "Spend a day exploring a new city.",
            "Take a scenic drive together.",
            "Spend the day gardening together.",
            "Go to a comedy show or improv night.",
            "Have a spa day at home.",
            "Take a dance class together.",
            "Plan a surprise picnic or outdoor activity.",
            "Visit a nearby zoo or aquarium.",
            "Have a photo shoot day, taking pictures together at various spots."
        ],
        .physicalTouch: [
            "Give your partner a massage.",
            "Hold hands while taking a walk.",
            "Cuddle on the couch while watching a movie.",
            "Give your partner a long hug.",
            "Play with your partner’s hair.",
            "Give your partner a kiss on the forehead.",
            "Sit close to your partner during dinner.",
            "Hold your partner while falling asleep.",
            "Give your partner a surprise kiss.",
            "Dance together in your living room.",
            "Give your partner a back scratch.",
            "Run your fingers along your partner’s arm.",
            "Give your partner a foot massage.",
            "Cuddle in bed before starting the day.",
            "Hold your partner’s face while talking.",
            "Give your partner a playful nudge.",
            "Sit on your partner’s lap.",
            "Walk arm-in-arm together.",
            "Give your partner a kiss on the hand.",
            "Touch your partner’s arm while laughing.",
            "Give your partner a gentle shoulder rub.",
            "Hold your partner from behind while they’re cooking.",
            "Give your partner a long kiss goodbye.",
            "Give your partner a playful tickle.",
            "Rest your head on your partner’s shoulder.",
            "Give your partner a kiss goodnight.",
            "Caress your partner’s cheek.",
            "Hold your partner while they’re feeling down.",
            "Stroke your partner’s back.",
            "Give your partner a gentle forehead touch."
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
