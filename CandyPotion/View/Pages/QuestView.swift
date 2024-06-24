// QuestView.swift
import SwiftUI

struct QuestView: View {
    @StateObject private var viewModel = QuestViewModel()
    
    var body: some View {
        VStack {
            Picker("Select Love Language", selection: $viewModel.loveLanguage) {
                ForEach(LoveLanguageModel.allCases, id: \.self) { language in
                    Text(language.rawValue).tag(language)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            Spacer()
            
            CardView(quest: viewModel.getRandomQuest(for: viewModel.loveLanguage))
            CardView(quest: viewModel.getRandomQuest(for: viewModel.loveLanguage))
            CardView(quest: viewModel.getRandomQuest(for: viewModel.loveLanguage))
            
            Spacer()
        }
    }
}

#Preview {
    QuestView()
}
