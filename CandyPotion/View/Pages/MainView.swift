//
//  MainView.swift
//  CandyPotion
//
//  Created by Rangga Yudhistira Brata on 25/06/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var accountVM : AccountVM
    @State private var selectedTab: Int = 1
    
    var body: some View {
        VStack(spacing: 0) {
        
            switch selectedTab {
            case 0:
                NavigationView {
                    AchieveView()
                }
            case 1:
                NavigationView {
                    CandyBoxView()
                        .environmentObject(accountVM)
                }
            case 2:
                NavigationView {
                    JourneyNotesView()
                }
            default:
                NavigationView {
                    CandyBoxView()
                }
            }
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
            
        }
        .edgesIgnoringSafeArea(.bottom) // Ensure the Tab Bar goes to the bottom
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            TabBarItem(index: 0, selectedTab: $selectedTab, imageName: "book.fill", title: "Recipe Book")
            TabBarItem(index: 1, selectedTab: $selectedTab, imageName: "gift.fill", title: "Candy Box")
            TabBarItem(index: 2, selectedTab: $selectedTab, imageName: "note.text", title: "Journey Notes")
        }
        .padding(.horizontal, 10)
        .frame(height: 80, alignment: .center)
        .background(Color.white.opacity(0.75))
        .shadow(color: Color.black.opacity(0.3), radius: 0, x: 0, y: -0.33)
    }
}

struct TabBarItem: View {
    let index: Int
    @Binding var selectedTab: Int
    let imageName: String
    let title: String
    
    var body: some View {
        let isSelected = selectedTab == index
        let selectedColor = Color(red: 0.87, green: 0, blue: 0.47)
        
        Button(action: {
            selectedTab = index
        }) {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 24)
                    .foregroundColor(isSelected ? selectedColor : .gray)
                
                Text(title)
                    .font(Font.custom("Mali", size: 12).weight(.medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? selectedColor : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AccountVM())
}
