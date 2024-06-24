//
//  QuestPage.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 20/06/24.
//

import SwiftUI

struct ValidateQuestView: View {
    @StateObject private var viewModel = QuestViewModel()
    @State private var isCompleted = false
    
    var body: some View {
        VStack {
            List(viewModel.quests) { quest in
                HStack{
                    VStack(alignment: .leading) {
                        Text(quest.description)
                            .font(.headline)
                        
                        Text(formatDate(quest.dateQuest))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    
                    Button(action: {
                        // Toggle the completion status
                        isCompleted.toggle()
                    }) {
                        Text("Valid")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 5)
                    }
                    
                }
               
            }
            
            Spacer()
        }
        .navigationBarTitle("Quest Validation")
        .onAppear {
//            viewModel.fetchQuests()
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
}

#Preview {
    ValidateQuestView()
}
