import SwiftUI

struct MainView: View {
    @State private var showTodayQuest = false
    @AppStorage("email") var email: String?
    @AppStorage("partnerID") var partnerID: String?
    
    var body: some View {
        ZStack {
            Image("Main Menu")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
            
            Button(action: {
                print("Log")
                logout()
            }, label: {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            })
        }
        .sheet(isPresented: $showTodayQuest) {
            TodayQuestView(presentationMode: $showTodayQuest)
                .background(Color(red: 1, green: 0.96, blue: 0.95))
                .presentationDetents([.fraction(0.10), .fraction(0.60)])
                .interactiveDismissDisabled(true) // Disable interactive dismissal
        }
        .onAppear {
//            print("parner: " ,partnerID!)
            showTodayQuest = true
        }
    }
}

func logout() {
    print("Logout")
    UserDefaults.standard.removeObject(forKey: "token")
    UserDefaults.standard.removeObject(forKey: "partnerID")
    UserDefaults.standard.removeObject(forKey: "invitationCode")
    UserDefaults.standard.removeObject(forKey: "loveLanguage")
    UserDefaults.standard.removeObject(forKey: "email")
}

struct TodayQuestView: View {
    @Binding var presentationMode: Bool
    @State private var dragOffset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Today Quest")
                    .font(.custom("Mali-Bold", size: 24))
                    .padding(.top, 20)
                
                Button(action: {
                    logout()
                }, label: {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                })
                
                QuestView()
                    .opacity(dragOffset < geometry.size.height / 4 ? 1 : 0)
                
                Text("This Week’s Quest")
                    .font(.custom("Mali-Bold", size: 24))
                
                QuestView()
                
                
                Spacer()
            }
            .background(Color(red: 1, green: 0.96, blue: 0.95))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.height
                    }
                    .onEnded { value in
                        if dragOffset > geometry.size.height / 4 {
//                            presentationMode = false
                        }
                        dragOffset = 0.0
                    }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MainView()
}
