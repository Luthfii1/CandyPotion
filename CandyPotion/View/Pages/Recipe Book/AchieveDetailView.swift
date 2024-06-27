//
//  AchievementDetailView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 26/06/24.
//

import SwiftUI

struct AchieveDetailView: View {
    var month: String
    var badge: String
    var candycount: Int

    var body: some View {
        NavigationView {
            ZStack {
                Image("bg-light").ignoresSafeArea()

                VStack {
                    Spacer().frame(height: 72)
                    ScrollView {
                        if badge == "GOLD" {
                            Image(month)
                                .resizable()
                                .frame(width: 367, height: 518)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.yellow, lineWidth: 4)
                                )
                        } else if badge == "SILVER" {
                            Image(month)
                                .resizable()
                                .frame(width: 367, height: 518)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 4)
                                )
                        } else if badge == "BRONZE" {
                            Image(month)
                                .resizable()
                                .frame(width: 367, height: 518)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.orange, lineWidth: 4)
                                )
                        } else if badge == "BROKE" {
                            Image("broke")
                                .resizable()
                                .frame(width: 367, height: 518)
                        }
                        
                        Spacer().frame(height: 36)

                        ListLog(month: month)
                    }
                }
            }

        }.navigationTitle(month)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AchieveDetailView(month: "January", badge: "Gold", candycount: 25)
}
