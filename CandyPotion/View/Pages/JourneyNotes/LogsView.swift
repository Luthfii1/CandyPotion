//
//  LogsView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 26/06/24.
//

import SwiftUI

struct LogsView: View {
    @StateObject private var viewModel = QuestPerMonthVM(month: 6, year: 2024)
    
    var body: some View {
        VStack(spacing: 0){
            Image("Logs Bar")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            ScrollView {
                ZStack(alignment: .top){
                    VStack(spacing: 0){
                        Image("Paper Notes")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        ForEach(viewModel.questList) { _ in
                            Image("Paper Notes Small")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    
                    
                    
                    VStack(spacing: 10) {
                        if viewModel.condition.isLoading {
                            ProgressView("Loading logs...")
                        } else {
                            ForEach(viewModel.questList) { log in
                                LogCardView(log: log)
                            }
                        }
                    }
                    .padding()
                }
                
                
                
            }
        }
        .onAppear {
            viewModel.getAllQuestByMonth()
        }
    }
}

struct LogCardView: View {
    var log: Log
    
    var body: some View{
        VStack{
            HStack {
                Image("Candy Image Quest")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 86, height: 86, alignment: .leading)
                
                VStack(alignment: .leading) {
                    Text(log.description)
                        .font(Font.custom("Mali-Bold", size: 14))
                        .foregroundColor(.black)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(Color(red: 0.79, green: 0.77, blue: 0.81))
                            .cornerRadius(7)
                            .frame(width: 120, alignment: .leading)
                        
                        
                        Text(convertDateString(log.dateQuest))
                            .font(Font.custom("Mali-Bold", size: 12))
                            .foregroundColor(.black)
                            .padding(.horizontal, 10) // Menambahkan padding horizontal untuk fleksibilitas
                            .padding(.vertical, 5)    // Menambahkan padding vertikal untuk fleksibilitas
                    }
                    
                }
            }
            .frame(width: 330, height: 40, alignment: .leading)
        }
        .frame(width: 361, height: 113)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
        )
        
    }
    
    private func convertDateString(_ dateString: String) -> String {
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
    LogsView()
}
