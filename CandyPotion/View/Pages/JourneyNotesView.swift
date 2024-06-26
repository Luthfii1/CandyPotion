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
                HStack{
                    Button {
                        currentView = "Logs"
                    } label: {
                        Text(verbatim: "Logs")
                    }
                    
                    Button {
                        currentView = "Assess"
                    } label: {
                        Text(verbatim: "Assess")
                    }
                }
                
                if currentView == "Logs"{
                    ScrollView{
                        LogsView()
                    }
                    
                } else{
                    AssessView()
                }
                
                
            }.padding(.top, 120)
            
        }.ignoresSafeArea(edges: .all)
        
    }
}

#Preview {
    JourneyNotesView()
}
