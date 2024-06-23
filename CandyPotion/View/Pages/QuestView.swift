// QuestView.swift
// QuestView.swift
import SwiftUI

struct QuestView: View {
    @StateObject private var viewModel = QuestViewModel()
    @State private var selectedQuest: String = ""
    @State private var selectedQuestId: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            if !selectedQuest.isEmpty {
                HStack {
                    CardView(quest: selectedQuest)
                }
            }
            
            Spacer()
        }
        .onAppear {
            selectedQuest = viewModel.getRandomQuest(for: viewModel.loveLanguage)
            print(selectedQuest)
            postQuest(description: selectedQuest)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Feedback"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
//https://mc2-be.vercel.app/log/uploadQuest/6675010198feecc0c9ed4b19
    
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
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
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
                        self.alertMessage = "Feedback sent successfully! Quest ID: \(decodedResponse.result._id)"
                        self.showAlert = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alertMessage = "Error decoding response: \(error)"
                        print(error)
                        self.showAlert = true
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Failed to encode feedback"
                self.showAlert = true
            }
        }
    }
    
    
}

struct QuestFeedback: Codable {
    let type: String
    let description: String
}



struct QuestResponse: Decodable {
    let messages: String
    let result: Result
}

#Preview {
    QuestView()
}

