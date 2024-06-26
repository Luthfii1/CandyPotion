//
//  ListLog.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 26/06/24.
//

import SwiftUI

struct ListLog: View {
    var month: String
    @StateObject var questPerMonth = QuestPerMonthViewModel(month: 6, year: 2024)

    var body: some View {
        VStack {
            ZStack {
                Image("top")
                Text("\(month) Logs")
                    .font(
                        Font.custom("Mali", size: 24)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(width: 319, height: 36, alignment: .top)
            }

            ZStack {
                Image("bg-paper-top")
                HStack {
                    Image("frame")

                    Spacer().frame(width: 20)
                    VStack {
                        Text("Candies Collected:")
                            .font(
                                Font.custom("Mali", size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 129, height: 52, alignment: .topLeading)

                        Text("21/31")
                            .font(
                                Font.custom("Mali", size: 40)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .frame(width: 129, height: 52, alignment: .topLeading)
                    }
                }
            }

            VStack {
                ForEach(questPerMonth.questList) { quest in
                    ZStack {
                        Image("bg-paper-3")
                        CardLogView(quest: quest.description, date: quest.dateQuest)
                    }
                   
                }
            }
           
        }
        .onAppear {
            questPerMonth.getAllQuestByMonth()
        }
    }
}

#Preview {
    ListLog(month: "January")
}
