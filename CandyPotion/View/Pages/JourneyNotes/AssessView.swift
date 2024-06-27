//
//  AssessView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 26/06/24.
//

import SwiftUI


struct AssessView: View {
    
    @StateObject private var viewModel = QuestViewModel()
    
    var body: some View {
        
        VStack(spacing: 0) {
            Image("Assess Bar")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            ScrollView {
                VStack(spacing: 10) {
                    Text("How was your \npartner’s quests?").font(Font.custom("Mali-Bold", size: 24))
                        .foregroundColor(Color(red: 0.31, green: 0.12, blue: 0.24))
                    ForEach(viewModel.quests) { quest in
                        CardAssessment(quest: quest).padding(.top, 20)
                    }
                    Rectangle()
                        .frame(width: 500, height: 500, alignment: .center)
                    .foregroundStyle(Color.clear)
                }
                .padding()
                .background(
                    Image("Paper Notes")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
            }
        }
    }
}

#Preview {
    AssessView()
}


struct CardAssessment: View {
    @State private var isCardVisible = true
    @State private var fadeOut = false
    
    @State private var isSad: Bool = false
    @State private var isOkay: Bool = false
    @State private var isHappy: Bool = false
    
    var quest: QuestPartner
    
    var selectedImage: Image? {
        if isSad {
            return Image("Rating Red")
        } else if isOkay {
            return Image("Rating Yellow")
        } else if isHappy {
            return Image("Rating Green")
        } else {
            return nil
        }
    }
    
    var body: some View {
        ZStack {
            if isCardVisible {
                VStack {
                    HStack {
                        Image("Candy Image Quest")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 86, height: 86, alignment: .leading)
                        
                        VStack(alignment: .leading) {
                            Text(quest.description)
                                .font(Font.custom("Mali-Bold", size: 14))
                                .foregroundColor(.black)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(Color(red: 0.79, green: 0.77, blue: 0.81))
                                    .cornerRadius(7)
                                    .frame(width: 120, alignment: .center)
                            
                                
                                Text(convertDateString(quest.dateQuest))
                                    .font(Font.custom("Mali-Bold", size: 12))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 10) // Menambahkan padding horizontal untuk fleksibilitas
                                    .padding(.vertical, 5)    // Menambahkan padding vertikal untuk fleksibilitas
                            }
                        }
                    }
                    .frame(width: 300, height: 40, alignment: .leading)
                    .offset(y: 10)
                    
                    if let image = selectedImage {
                        HStack {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                            
                            Text("Thank you for sharing \nyour feeling today")
                                .font(Font.custom("Mali-Bold", size: 20))
                                .foregroundColor(Color(red: 0.31, green: 0.12, blue: 0.24))
                        }
                        .padding(.top, 50)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    fadeOut = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isCardVisible = false
                                }
                            }
                        }
                    } else {
                        VStack {
                            HStack(spacing: 20) {
                                Button(action: {
                                    self.isSad = true
                                    self.isOkay = false
                                    self.isHappy = false
                                    triggerImageAppearance()
                                    postRating(rating: 1, questID: quest.id)
                                }) {
                                    Image("Rating Red")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75)
                                }
                                
                                Button(action: {
                                    self.isSad = false
                                    self.isOkay = true
                                    self.isHappy = false
                                    triggerImageAppearance()
                                    postRating(rating: 2, questID: quest.id)
                                }) {
                                    Image("Rating Yellow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75)
                                }
                                
                                Button(action: {
                                    self.isSad = false
                                    self.isOkay = false
                                    self.isHappy = true
                                    triggerImageAppearance()
                                    postRating(rating: 3, questID: quest.id)
                                }) {
                                    Image("Rating Green")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75)
                                }
                            }
                            .padding(.top, 50)
                            
                            Text("Please pick one that suits you")
                                .font(Font.custom("Mali-Bold", size: 16))
                                .foregroundColor(Color(red: 0.31, green: 0.12, blue: 0.24))
                                .offset(y: 10)
                        }
                    }
                }
                .frame(width: 360, height: 250)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                )
                .opacity(fadeOut ? 0 : 1)
                .animation(.easeInOut(duration: 1), value: fadeOut)
            }
        }
    }
    
    private func triggerImageAppearance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                fadeOut = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isCardVisible = false
            }
        }
    }
    
    private func postRating(rating: Int, questID: String) {
        guard let url = URL(string: "https://mc2-be.vercel.app/log/updateQuest/6674ef2d9c4cd0231d9ace69") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["rating": rating, "idQuest": questID]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error posting rating: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                }
            } catch let error {
                print("Error parsing response: \(error)")
            }
        }.resume()
    }
    
    private func convertDateString(_ dateString: String) -> String {
        // Define the input date formatter
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Define the output date formatter
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, dd MMMM"
        outputFormatter.locale = Locale(identifier: "en_US")
        
        // Parse the input date string to a Date object
        if let date = inputFormatter.date(from: dateString) {
            // Format the Date object to the desired output string
            let outputDateString = outputFormatter.string(from: date)
            return outputDateString
        } else {
            // Return the original string if parsing fails
            return dateString
        }
    }

}




