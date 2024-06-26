// CardView.swift
import SwiftUI

struct CardQuest: View {
    @StateObject private var questVM = QuestVM()
    @State var image: String
    @State var desc: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center){
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .leading)
                    .padding(.leading, 12)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text(desc)
                        .font(Font.custom("Mali-Bold", size: 14))
                        .foregroundColor(.black)
                    
                    Text(questVM.dailyChecked ? "Done" : questVM.timeRemaining)
                        .font(Font.custom("Mali-Bold", size: 12))
                        .foregroundColor(.black)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 10)
                        .background(questVM.dailyChecked ?
                                    Color(red: 0.71, green: 0.95, blue: 0.75) :
                                        Color(red: 0.79, green: 0.77, blue: 0.81))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                Spacer()
                
                Button(action: {
                    questVM.updateQuest(isCompleted: true)
                    questVM.isChecked = true
                    questVM.questCounter += 1
                }) {
                    Image(questVM.isChecked ? "Check Done" : "Check")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding(.trailing, 12)
                }
                .disabled(questVM.isChecked)
            }
        }
        .frame(width: 360, height: 120)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(questVM.isChecked ?
                        Color(red: 0.23, green: 0.8, blue: 0.22) :
                            Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
        )
        .padding()
        .onAppear(perform: questVM.startTimer)
        .alert(isPresented: $questVM.condition.showAlert) {
            Alert(title: Text("Update Status"),
                  message: Text(questVM.condition.alertMessage),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    CardQuest(image: QuestImage.init().isDaily, desc: "Write a heartfelt love letter to your partner.")
}

