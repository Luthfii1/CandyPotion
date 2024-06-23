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
            Picker("Select Love Language", selection: $viewModel.loveLanguage) {
                ForEach(LoveLanguageModel.allCases, id: \.self) { language in
                    Text(language.rawValue).tag(language)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Spacer()
            
            if !selectedQuest.isEmpty {
                HStack {
                    CardView(quest: selectedQuest)
                    
                    Button(action: {
                        updateQuest(isCompleted: true)
                    }) {
                        Text("Done")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                selectedQuest = viewModel.getRandomQuest(for: viewModel.loveLanguage)
                postQuest(description: selectedQuest)
            }) {
                Text("Get New Quest")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Feedback"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func postQuest(description: String) {
        guard let url = URL(string: "https://mc2-be.vercel.app/log/uploadQuest/6675010198feecc0c9ed4b19") else { return }
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
    
    func updateQuest(isCompleted: Bool) {
        guard let url = URL(string: "https://mc2-be.vercel.app/log/updateQuest/6675010198feecc0c9ed4b19") else { return }
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
                        self.alertMessage = "Failed to update quest: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }
                
                guard let data = data else {
                    print("no data received")
                    return
                }
                
                print("data: ", data)
                
                DispatchQueue.main.async {
                    self.alertMessage = "Quest updated successfully!"
                    self.showAlert = true
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Failed to encode update"
                self.showAlert = true
            }
        }
    }
}

struct QuestFeedback: Codable {
    let type: String
    let description: String
}

struct QuestUpdate: Codable {
    let isCompleted: Bool
}

struct QuestResponse: Decodable {
    let messages: String
    let result: Result
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


#Preview {
    QuestView()
}
