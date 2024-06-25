//
//  WeeklyQuestView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 24/06/24.
//

import SwiftUI

struct WeeklyQuestView: View {
    let quest: String
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isChecked: Bool = false
    @Binding var dayCounter: Int
    
    @State private var endDate: Date = Date().addingTimeInterval(60 * 60) // 1 hour from now
    @State private var timeRemaining: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                // Outer
            }
            .frame(width: 360, height: 120)
            .background(isChecked ? Color(red: 0.51, green: 1, blue: 0.53) : Color(red: 1, green: 0.9, blue: 0.51))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isChecked ? Color(red: 0.23, green: 0.8, blue: 0.22) : Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
            )
            .padding()
            .onAppear(perform: startTimer)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            // Inner
            VStack {
                HStack(alignment: .center){
                    Image("Elephant Image Quest")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 86, height: 86, alignment: .leading)
                    
                    VStack(alignment: .leading){
                        Text(quest).font(Font.custom("Mali-Bold", size: 14))
                            .foregroundColor(.black)
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 78, height: 22, alignment: .leading)
                                .background(isChecked ? Color(red: 0.71, green: 0.95, blue: 0.75) : Color(red: 0.79, green: 0.77, blue: 0.81))
                                .cornerRadius(7)
                            
                            Text(isChecked ? "Done" : timeRemaining).font(Font.custom("Mali-Bold", size: 12))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Button(action: {
                        updateQuest(isCompleted: true)
                        self.isChecked = true
                        dayCounter += 1
                    }) {
                        Image(isChecked ? "Check Done" : "Check")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56, height: 56, alignment: .center)
                            .padding(.trailing, 10)
                    }
                    .disabled(isChecked)
                }
                
            }
            .frame(width: 340, height: 100)
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isChecked ? Color(red: 0.23, green: 0.8, blue: 0.22) : Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
            )
            .padding()
            .onAppear(perform: startTimer)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Update Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func startTimer() {
        updateTimeRemaining()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateTimeRemaining()
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
                    print("Success!")
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


#Preview {
    WeeklyQuestView(quest: "Write a heartfelt love letter to your partner.", dayCounter: .constant(0))
}
