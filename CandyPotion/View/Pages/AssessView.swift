//
//  DummyView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 26/06/24.
//

import SwiftUI

struct AssessView: View {
    @State private var isSad: Bool = false
    @State private var isOkay: Bool = false
    @State private var isHappy: Bool = false
    
    var body: some View {
        VStack{
            Image("Assess Bar")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            
            
            ZStack{
                ScrollView{
                    ZStack{
                        
                        Image("Paper Notes")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                        
                        VStack{
                            Text("How was your \npartner’s quests?").font(Font.custom("Mali-Bold", size: 24))
                                .foregroundColor(Color(red: 0.31, green: 0.12, blue: 0.24))
                            
                            ZStack{
                                VStack {
                                    // Outer
                                }
                                .frame(width: 360, height: 250)
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                                )
                                VStack{
                                    HStack{
                                        Text("Quest here").font(Font.custom("Mali-Bold", size: 16))
                                            .foregroundColor(Color(red: 0.31, green: 0.12, blue: 0.24))
                                        
                                    }
                                    
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
                                    
                                    Text("Please pick one that suits you").font(Font.custom("Mali-Bold", size: 16))
                                        .foregroundColor(Color(red: 0.31, green: 0.12, blue: 0.24))
                                }
                                
                                
                                
                                
                            }
                            
                            
                            
                            Spacer()
                            
                        }
                    }
                }
                
                
                
                
                
                
            }
            
            
        }
        
    }
}

#Preview {
    AssessView()
}
