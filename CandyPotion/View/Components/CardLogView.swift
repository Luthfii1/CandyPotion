//
//  CardLogView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 26/06/24.
//

import Foundation
import SwiftUI

struct CardLogView: View {
    var quest: String
    var date: String

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack(alignment: .center) {
                    Spacer().frame(width: 75)
                    Image("Candy Image Quest")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 86, height: 86, alignment: .leading)

                    VStack(alignment: .leading) {
                        Text(quest).font(Font.custom("Mali-Bold", size: 14))
                            .foregroundColor(.black)

                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 175, height: 22, alignment: .leading)
                                .background(Color(red: 0.79, green: 0.77, blue: 0.81))
                                .cornerRadius(7)
                            Text(convertDateString(date))
                                .font(
                                    Font.custom("Mali", size: 12)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(width: 175, alignment: .top)
                        }.frame(width: 300, height: 40, alignment: .leading)
                    }
                }
                .frame(width: 361, height: 113)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                )
            }
        }
    }

    func convertDateString(_ dateString: String) -> String {
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

#Preview {
    CardLogView(quest: "Write a heartfelt love letter to your partner.", date: "Sunday, 3 May")
}
