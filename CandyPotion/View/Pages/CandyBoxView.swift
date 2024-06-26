import SwiftUI

struct CandyBoxView: View {
    @StateObject private var questVM = QuestVM()
    @EnvironmentObject private var accountVM : GetAccountVM
    
    var body: some View {
        ZStack {
            Image(questVM.bgImages[min(questVM.weeklyStreak, questVM.bgImages.count - 1)] )
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
            
            Button(action: {
                print("Log")
                accountVM.logout()
            }, label: {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(.red)
                    .cornerRadius(8)
            })
        }
        .sheet(isPresented: .constant(true)) {
            GeometryReader { geometry in
                VStack {
                    Button(action: {
                        accountVM.logout()
                        print("Hallo")
                    }, label: {
                        Text("Logout")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    })
                    .padding(.top, 30)
                    
                    ForEach(QuestType.allCases, id: \.self) { questType in
                        QuestCard(questType: questType)
                            .environmentObject(questVM)
                            .padding(.vertical, 10)
                    }
                    
                    Spacer()
                }
            }
            .background(Color(red: 1, green: 0.96, blue: 0.95))
            .presentationDetents([.fraction(0.10), .fraction(0.60)])
            .interactiveDismissDisabled(true)
        }
        .task {
            accountVM.getAccount { success in
                if success {
                    print("Person's name: \(accountVM.person.name)")
                } else {
                    print("Failed to fetch account data")
                }
            }
            
            accountVM.getPartner { success in
                if success {
                    print("Partner name: \(accountVM.partner.name)")
                    
                    if let loveLanguage = accountVM.partner.loveLanguage {
                        questVM.getRandomQuest(loveLang: loveLanguage)
                    } else {
                        print("Partner love language is nil")
                    }
                } else {
                    print("Failed to fetch account data")
                }
            }
        }
    }
}

struct TodayQuestView: View {
    //    @EnvironmentObject private var questVM: QuestVM
    //    @EnvironmentObject private var accountVM: GetAccountVM
    @State private var dragOffset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Button(action: {
                    //                    accountVM.logout()
                    print("Hallo")
                }, label: {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                })
                .padding(.top, 30)
                
                ForEach(QuestType.allCases, id: \.self) { questType in
                    //                    QuestCard(questType: questType)
                    //                        .environmentObject(questVM)
                    Text("Hi")
                        .padding(.vertical, 10)
                }
                
                Spacer()
            }
        }
        edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    CandyBoxView()
        .environmentObject(GetAccountVM())
}
