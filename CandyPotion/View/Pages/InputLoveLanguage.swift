//
//  InputLoveLanguage.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 23/06/24.
//

import SwiftUI

struct InputLoveLanguage: View {
    @State private var selectedLoveLang: String = ""
    private var id = UserDefaults.standard.string(forKey: "_id")
    private var token = UserDefaults.standard.value(forKey: "token")
    private var person = UserDefaults.standard.person(forKey: "person")

    var body: some View {
        ZStack {
            Color(.purpleCandy).ignoresSafeArea()
            Image("background").resizable().opacity(0.5).ignoresSafeArea()

            VStack {
                Text("What is your\nLove Language?")
                    .font(
                        Font.custom("Mali", size: 32)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))

                LoveLangButton(lovelang: self.$selectedLoveLang, text: "ACTS_OF_SERVICE")
                LoveLangButton(lovelang: self.$selectedLoveLang, text: "PHYSICAL_TOUCH")
                LoveLangButton(lovelang: self.$selectedLoveLang, text: "QUALITY_TIME")
                LoveLangButton(lovelang: self.$selectedLoveLang, text: "RECEIVING_GIFTS")
                LoveLangButton(lovelang: self.$selectedLoveLang, text: "WORDS_OF_AFFIRMATION")
                
                Spacer().frame(height: 72)

                Button {
                    self.updateLoveLanguage()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 329, height: 51)
                            .background(Color(red: 0.56, green: 0.4, blue: 0.78))
                            .cornerRadius(12)
                        Text("Confirm")
                            .font(
                                Font.custom("Mali", size: 24)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
    }

    func updateLoveLanguage() {
        print(self.selectedLoveLang)

        guard let url = URL(string: "http://mc2-be.vercel.app/account/updateAccount/\(id!)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let loveLang = LoveLangRequest(loveLanguage: self.selectedLoveLang)

        do {
            let jsonData = try JSONEncoder().encode(loveLang)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                    return
                }

                guard let data = data else {
                    DispatchQueue.main.async {
                        print("No data received")
                    }
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(CodeResponse.self, from: data)
                    print(decodedResponse)
                    print(data)

                    self.person?.getAccount(token: self.token as! String) { success in
                        if success {
                            UserDefaults.standard.setPerson(self.person!, forKey: "person")
                            UserDefaults.standard.set(self.person!.partnerID, forKey: "partnerID")
                            UserDefaults.standard.set(self.person!.loveLanguage.rawValue, forKey: "loveLanguage")

                        } else {
                            print("Failed to fetch account details")
                        }
                    }

                } catch {
                    DispatchQueue.main.async {
                        print(error.localizedDescription)
                    }
                }
            }.resume()

        } catch {}
    }
}

struct LoveLangButton: View {
    @Binding var lovelang: String
    var text: String

    var body: some View {
        Button {
            self.lovelang = self.text
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 329, height: 73)
                    .background(self.lovelang == self.text ? Color(red: 1, green: 0.41, blue: 0.59) : .white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 1.5)
                            .stroke(self.lovelang == self.text ? Color(red: 0.87, green: 0, blue: 0.47) : Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                    )

                Text("\(self.text)")
                    .font(
                        Font.custom("Mali", size: 18)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(self.lovelang == self.text ? Color.white : Color.black)
                    .frame(width: 200, height: 24, alignment: .top)
            }
        }
    }
}

struct LoveLangRequest: Codable {
    var loveLanguage: String
}

#Preview {
    InputLoveLanguage()
}
