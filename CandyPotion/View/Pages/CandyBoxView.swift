import SwiftUI

struct CandyBoxView: View {
    @StateObject private var questVM = QuestVM()
    @EnvironmentObject private var accountVM : GetAccountVM
    // =====================
    @State private var defaultHeight: CGFloat = 0.8
    @State private var offsetVal = 700
    
    var body: some View {
        ZStack {
            Image(questVM.bgImages[min(questVM.weeklyStreak, questVM.bgImages.count - 1)] )
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
            
            Button(action: {
                accountVM.logout()
            }, label: {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            })
            
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Capsule()
                            .frame(width: 80, height: 10, alignment: .center)
                            .foregroundStyle(.gray)
                            .padding(.top, 20)
                        
                        ForEach(QuestType.allCases, id: \.self) { questType in
                            QuestCard(questType: questType)
                                .environmentObject(questVM)
                                .padding(.vertical, 10)
                        }
                        
                        Rectangle()
                            .frame(width: 0, height: 0)
                            .padding(.bottom, 200)
                    }
                    .background(Color(red: 1, green: 0.96, blue: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(width: geometry.size.width, alignment: .center)
                    .offset(y: geometry.size.height * defaultHeight)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height < -12 {
                                    defaultHeight = 0.3
                                    offsetVal = 300
                                }
                                
                                if value.translation.height > 12 {
                                    defaultHeight = 0.8
                                    offsetVal = 700
                                }
                            }
                    )
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .task {
            accountVM.getAccount { success in
                if success {
                    print("Person's name: \(accountVM.person.name)")
                } else {
                    print("Failed to fetch account data getAccount")
                }
            }
            
            //            accountVM.getPartner { success in
            //                if success {
            //                    print("Partner name: \(accountVM.partner.name)")
            //
            //                    if let loveLanguage = accountVM.partner.loveLanguage {
            //                        questVM.getRandomQuest(loveLang: loveLanguage)
            //                    } else {
            //                        print("Partner love language is nil")
            //                    }
            //                } else {
            //                    print("Failed to fetch account data getPartner")
            //                }
            //            }
        }
    }
}

#Preview {
    CandyBoxView()
        .environmentObject(GetAccountVM())
}
