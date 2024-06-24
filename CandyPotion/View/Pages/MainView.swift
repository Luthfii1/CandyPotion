import SwiftUI

struct MainView: View {
    @State private var showTodayQuest = false
    
    var body: some View {
        ZStack {
            Image("Main Menu")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(edges: .all)
            
            Button(action: logout) {
                Text("Logout")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showTodayQuest) {
            TodayQuestView(presentationMode: $showTodayQuest)
                .background(Color(red: 1, green: 0.96, blue: 0.95))
                .presentationDetents([.fraction(0.10), .fraction(0.60)])
                .interactiveDismissDisabled(true) // Disable interactive dismissal
        }
        .onAppear {
            showTodayQuest = true
        }
    }
}

struct TodayQuestView: View {
    @Binding var presentationMode: Bool
    @State private var dragOffset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Today's Quest")
                    .font(.custom("Mali-Bold", size: 24))
                    .padding(.top, 20)
                
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
                            presentationMode = false
                        }
                        dragOffset = 0.0
                    }
            )
        }
        .edgesIgnoringSafeArea(.all)
        
        
    }
}

func logout() {
    UserDefaults.standard.removeObject(forKey: "token")
}
    
#Preview {
    MainView()
}
