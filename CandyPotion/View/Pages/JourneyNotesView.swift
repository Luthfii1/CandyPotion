//
//  JourneyNotesView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 24/06/24.
//

import SwiftUI

struct JourneyNotesView: View {
    @State private var isSad: Bool = false
    @State private var isOkay: Bool = false
    @State private var isHappy: Bool = false
    
    
    
    var body: some View {
            ZStack{
                Color(red: 1, green: 0.96, blue: 0.88)
                
                ScrollView{
                    VStack{
                        
                        ZStack{
                            Rectangle()
                                .frame(width: 435, height: 130, alignment: .center)
                                .foregroundStyle(Color(red: 0.14, green: 0.13, blue: 0.22))
                            
                            Text("Journey Notes").font(Font.custom("Mali-Bold", size: 24))
                                .foregroundColor(.white)
                                .padding(.top, 50)
                            
                            
                        }
                        
                        ZStack{
                            Image("partner question")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 435, height: 160, alignment: .center)
                            
                            HStack(spacing: 20){
                                
                                Button(action: {
                                    self.isSad = true
                                }) {
                                    Image("Rating Red")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75, alignment: .center)
                                }
                                
                                Button(action: {
                                    self.isOkay = true
                                }) {
                                    Image("Rating Yellow")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75, alignment: .center)
                                }
                                
                                Button(action: {
                                    self.isHappy = true
                                }) {
                                    Image("Rating Green")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 75, height: 75, alignment: .center)
                                }
                                
                                
                            }.padding(.top, 40)
                            
                            
                        }
                        
                        
                        
//                        QuestView()
//                        
//                        QuestView()
//                        
//                        QuestView()
//                        
//                        QuestView()
                        
                        Spacer()
                    }
                }
                
                
            }.ignoresSafeArea(.all)
    }
}

#Preview {
    JourneyNotesView()
}
