//
//  QuestCard.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 25/06/24.
//
import SwiftUI

struct QuestCard: View {
    @EnvironmentObject private var questVM: QuestVM
    @State var questType: QuestType
    private var isDaily : Bool {
        if questType == .daily {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        VStack {
            if isDaily {
                Text("Today's Quest")
                    .font(.custom("Mali-Bold", size: 24))
            } else {
                Text("Couple's Quest")
                    .font(.custom("Mali-Bold", size: 24))
            }
            
            VStack {
                HStack(alignment: .center){
                    Image(questVM.getImage(isDaily: isDaily, isLogo: true))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80, alignment: .leading)
                        .padding(.leading, 12)
                    
                    VStack(alignment: .leading){
                        Text(questVM.task(for: questType))
                            .font(Font.custom("Mali-Bold", size: 14))
                            .foregroundColor(.black)
                        
                        Text(questVM.getTimeRemaining(isDaily: isDaily))
                            .font(Font.custom("Mali-Bold", size: 12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(questVM.isCompleted(isDaily: isDaily) ? Color(red: 0.71, green: 0.95, blue: 0.75) : Color(red: 0.79, green: 0.77, blue: 0.81))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                    Button(action: {
                        questVM.updateQuest(isCompleted: true, questType: questType)
                    }) {
                        Image(questVM.getImage(isDaily: isDaily, isLogo: false))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding(.trailing, 12)
                    }
                    .disabled(questVM.isCompleted(isDaily: isDaily))
                    
                }
            }
            .frame(width: 360, height: 120)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(questVM.isCompleted(isDaily: isDaily) ? Color(red: 0.23, green: 0.8, blue: 0.22) : Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
            )
            .padding(isDaily ? 0 : 8)
            .background(isDaily ? .clear : .yellow)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isDaily ? .clear : questVM.isCompleted(isDaily: isDaily) ? Color(red: 0.23, green: 0.8, blue: 0.22) : Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
            )
            .padding(.horizontal)
            .onAppear(perform: questVM.startTimers)
            .alert(isPresented: $questVM.condition.showAlert) {
                Alert(title: Text("Update Status"), message: Text(questVM.condition.alertMessage), dismissButton: .default(Text("OK")))
        }
        }
    }
}

#Preview {
    QuestCard(questType: .weekly)
        .environmentObject(QuestVM())
}
