//
//  JourneyNotesView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 24/06/24.
//

import SwiftUI

struct JourneyNotesView: View {
    @State private var currentView: String = "Logs"
    
    
    
    var body: some View {
        ZStack{
            Image("BG Journey Notes")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            VStack{
                Text("Journey Notes")
                .font(Font.custom("Mali-Bold", size: 36))
                .foregroundColor(.black)
                .frame(width: 350, alignment: .leading)
                
                
                HStack(){
                    Button {
                        currentView = "Logs"
                    } label: {
                        CardTabJourneyNotesView(textRectangle: "Logs", isActive: currentView == "Logs")
                    }
                    
                    Button {
                        currentView = "Assess"
                    } label: {
                        CardTabJourneyNotesView(textRectangle: "Assess", isActive: currentView == "Assess").padding(.trailing, 5)
                    }
                }
                
                if currentView == "Logs"{
                    ScrollView{
                        LogsView()
                    }.offset(y: -10)
                    
                } else{
                    AssessView()
                        .offset(y: -10)
                }
                
                Spacer()
            }
            .frame(width: 400, height: 800, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.top, 80)
            
        }.ignoresSafeArea(edges: .all)
        
    }
}

#Preview {
    JourneyNotesView()
}
