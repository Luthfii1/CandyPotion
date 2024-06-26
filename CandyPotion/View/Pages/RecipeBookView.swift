//
//  RecipeBookView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 25/06/24.
//

import SwiftUI

struct RecipeBookView: View {
    @State private var currentView: String = "Logs"
    var body: some View {
        Text("Recipe Book")
            .navigationTitle("Recipe Book")
        
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
                    CandyBoxView()
                }
            
            } else{
                AssessView()
            }
            
            
        }
    }
}


#Preview {
    RecipeBookView()
}
