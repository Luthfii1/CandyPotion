//
//  AchievementTicket.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 26/06/24.
//

import SwiftUI

struct AchievementBadge: View {
    var month: String
    var badge: String
    var candycount: Int

    var body: some View {
        
        ZStack {
            if badge == "GOLD" {
                Image(month)
                    .resizable()
                    .frame(width: 163, height: 243)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.yellow, lineWidth: 4)
                    )
            } else if badge == "SILVER" {
                Image(month)
                    .resizable()
                    .frame(width: 163, height: 243)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 4)
                    )
            } else if badge == "BRONZE" {
                Image(month)
                    .resizable()
                    .frame(width: 163, height: 243)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 4)
                    )
            } else if badge == "BROKE" {
                Image("broke")
                    .resizable()
                    .frame(width: 163, height: 243)
            }

            ZStack {
                Image("tape")
                Text("\(candycount)/30")
                    .font(
                        Font.custom("Mali", size: 14)
                            .weight(.bold)
                    )
                    .foregroundColor(.black)
                    .frame(width: 43, height: 18, alignment: .topLeading)
            }
            .offset(y: 110)
        }
    }
}

#Preview {
    AchievementBadge(month: "january", badge: "GOLD", candycount: 0)
}
