//
//  InputLoveLanguage.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 23/06/24.
//

import SwiftUI

struct InputLoveLanguage: View {
    @State private var selectedLoveLang: String = ""
    private var id = UserDefaults.standard.person(forKey: "person")?._id
    private var token = UserDefaults.standard.value(forKey: "token")
    private var person = UserDefaults.standard.person(forKey: "person")

    var body: some View {
        VStack {
            Text("What language describes you the most?")

            LoveLangButton(lovelang: self.$selectedLoveLang, text: "Acts of Service")
            LoveLangButton(lovelang: self.$selectedLoveLang, text: "Physical Touch")
            LoveLangButton(lovelang: self.$selectedLoveLang, text: "Quality Time")
            LoveLangButton(lovelang: self.$selectedLoveLang, text: "Receiving Gifts")
            LoveLangButton(lovelang: self.$selectedLoveLang, text: "Words of Affirmation")

            Button {
                self.updateLoveLanguage()
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 329, height: 46)
                        .background(Color(red: 0.58, green: 0.58, blue: 0.58))
                        .cornerRadius(10)
                    Text("Next")
                }
            }
        }
        .padding()
    }

    func updateLoveLanguage() {
        print(self.selectedLoveLang)

        guard let url = URL(string: "http://mc2-be.vercel.app/account/updateAccount/\(id ?? "")") else { return }
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
                    .frame(width: 330, height: 46)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .inset(by: 0.5)
                            .stroke(self.lovelang == self.text ? Color.blue : Color(red: 0.58, green: 0.58, blue: 0.58), lineWidth: 1)
                    )
                Text("\(self.text)")
                    .foregroundColor(self.lovelang == self.text ? Color.blue : Color.black)
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
