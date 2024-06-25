//
//  InputLoveLanguage.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 23/06/24.
//

import SwiftUI

struct InputLoveLanguage: View {
    @EnvironmentObject private var lovLangVM : InputLoveLanguageVM

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

                LoveLangButton(lovelang: $lovLangVM.selectedLovLang, text: "ACTS_OF_SERVICE")
                LoveLangButton(lovelang: $lovLangVM.selectedLovLang, text: "PHYSICAL_TOUCH")
                LoveLangButton(lovelang: $lovLangVM.selectedLovLang, text: "QUALITY_TIME")
                LoveLangButton(lovelang: $lovLangVM.selectedLovLang, text: "RECEIVING_GIFTS")
                LoveLangButton(lovelang: $lovLangVM.selectedLovLang, text: "WORDS_OF_AFFIRMATION")
                
                Spacer().frame(height: 72)

                Button {
                    lovLangVM.updateLoveLanguage()
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
        .alert(isPresented: $lovLangVM.condition.showAlert) {
            Alert(title: Text("Message"), message: Text(lovLangVM.condition.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoveLangButton: View {
    @Binding var lovelang: LOVELANGUAGE
    var text: String

    var body: some View {
        Button {
            if let loveLanguage = LOVELANGUAGE(rawValue: text) {
                lovelang = loveLanguage
            }
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 329, height: 73)
                    .background(lovelang.rawValue == text ? Color(red: 1, green: 0.41, blue: 0.59) : .white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .inset(by: 1.5)
                            .stroke(lovelang.rawValue == text ? Color(red: 0.87, green: 0, blue: 0.47) : Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                    )

                Text(text.replacingOccurrences(of: "_", with: " "))
                    .font(
                        Font.custom("Mali", size: 18)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(lovelang.rawValue == text ? Color.white : Color.black)
                    .frame(width: 200, height: 24, alignment: .top)
            }
        }
    }
}

#Preview {
    InputLoveLanguage()
        .environmentObject(InputLoveLanguageVM())
}
