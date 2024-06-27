//
//  AchievementView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 25/06/24.
//

import SwiftUI

struct AchieveView: View {
    @StateObject private var achievements = AchievementViewModel()
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("bg-light")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(alignment: .leading) {
                    Spacer().frame(height: 36)
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 393, height: 616)
                            .background(Color(red: 0.56, green: 0.4, blue: 0.78))
                            .overlay(
                                Rectangle()
                                    .inset(by: 1.5)
                                    .stroke(Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
                            )
                        TabView(selection: $selectedIndex) {
                            let monthList = achievements.monthList
                            let quantityList = achievements.quantityList
                            
                            ForEach(0 ..< 4, id: \.self) { index in
                                if let list = achievements.achievementList, list.count > index {
                                    let badge = list[index]
                                    let month = monthList![index]
                                    let quantity = quantityList![index]
                                    
                                    if (index + 1) % 2 != 0 {
                                        ZStack {
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    Image("breakthroughs").offset(y: 20)
                                                    Spacer().frame(width: 20)
                                                }
                                                Spacer()
                                            }
                                            Image("page-left")
                                                .resizable()
                                                .frame(width: 386, height: 592)
                                                .padding(.leading, 7)
                                            VStack {
                                                VStack {
                                                    HStack {
                                                        if badge[0].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            }
                                                        }
                                                        
                                                        if badge[1].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[1], badge: badge[1], candycount: quantity[1])
                                                            }
                                                        }
                                                    }
                                                    Spacer().frame(height: 20)
                                                    HStack {
                                                        if badge[2].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[2], badge: badge[2], candycount: quantity[2])
                                                            }
                                                        }
                                                        
                                                        if badge[3].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[3], badge: badge[3], candycount: quantity[3])
                                                            }
                                                        }
                                                    }
                                                }.padding(.leading, 30)
                                                HStack {
                                                    Text("\(index + 1)")
                                                        .font(
                                                            Font.custom("Mali", size: 20)
                                                                .weight(.semibold)
                                                        )
                                                        .padding(.leading)
                                                    
                                                    Spacer().frame(width: 225)
                                                    
                                                    Text("Recipes")
                                                        .font(
                                                            Font.custom("Mali", size: 20)
                                                                .weight(.semibold)
                                                        )
                                                }
                                            }
                                            VStack {
                                                HStack {
                                                    Spacer().frame(width: 10)
                                                    Image("recipes")
                                                    Spacer()
                                                }.padding(.horizontal).offset(y: 20)
                                                Spacer()
                                            }
                                        }
                                        
                                    } else {
                                        ZStack {
                                            //                                            Image("page-right")
                                            //                                                .resizable()
                                            //                                                .frame(width: 386, height: 592)
                                            //                                                .padding(.trailing, 7)
                                            
                                            OpenBook(selectedIndex: $selectedIndex)
                                            
                                            VStack {
                                                VStack {
                                                    HStack {
                                                        if badge[0].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            }
                                                        }
                                                        
                                                        if badge[1].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[1], badge: badge[1], candycount: quantity[1])
                                                            }
                                                        }
                                                    }
                                                    Spacer().frame(height: 20)
                                                    
                                                    HStack {
                                                        if badge[2].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[2], badge: badge[2], candycount: quantity[2])
                                                            }
                                                        }
                                                        
                                                        if badge[3].isEmpty {
                                                            Image("unknown")
                                                                .frame(width: 163, height: 243)
                                                            
                                                        } else {
                                                            NavigationLink {
                                                                AchieveDetailView(month: month[0], badge: badge[0], candycount: quantity[0])
                                                            } label: {
                                                                AchievementBadge(month: month[3], badge: badge[3], candycount: quantity[3])
                                                            }
                                                        }
                                                    }
                                                }.padding(.trailing, 30)
                                                HStack {
                                                    Text("Recipes")
                                                        .font(
                                                            Font.custom("Mali", size: 20)
                                                                .weight(.semibold)
                                                        )
                                                    
                                                    Spacer().frame(width: 225)
                                                    
                                                    Text("\(index + 1)")
                                                        .font(
                                                            Font.custom("Mali", size: 20)
                                                                .weight(.semibold)
                                                        )
                                                        .padding(.trailing)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Text("No data available")
                                }
                            }
                        }
                        .padding([.top, .bottom], 7.0)
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .never))
                        .cornerRadius(30)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .navigationTitle("Recipe Book")
            .onAppear {
                achievements.fetchAchievements()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AchieveView()
    }
}
