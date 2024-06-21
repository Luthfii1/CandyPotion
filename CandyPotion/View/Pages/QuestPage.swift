//
//  QuestPage.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 20/06/24.
//

import SwiftUI

struct QuestPage: View {
    @StateObject private var viewModel = QuestViewModel()
    
    @State private var isCompleted = false
    @State private var selectedQuest: String
    
    init() {
        let viewModel = QuestViewModel() // Create a temporary viewModel to get the quest
        _selectedQuest = State(initialValue: viewModel.getRandomQuest(for: viewModel.loveLanguage))
    }
    
    var body: some View {
        VStack {
            CardView(quest: selectedQuest)
                .padding()
            
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
                    .padding()
            }
            
            Text("Quest Completed: \(isCompleted ? "Yes" : "No")")
                .padding()
            
            Spacer()
        }
        .navigationBarTitle("Quest Validation")
    }
}

#Preview {
    QuestPage()
}
