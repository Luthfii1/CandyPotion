import SwiftUI

struct MainView: View {
    @State private var showTodayQuest = false
    @State private var dayCounter = 0
    
    // Array untuk menyimpan nama gambar berdasarkan dayCounter
    private let images = [
        "Main Menu",   // Default image (dayCounter == 0)
        "Main Menu 1", // Image for dayCounter == 1
        "Main Menu 2", // Image for dayCounter == 2
        "Main Menu 3", // Image for dayCounter == 3
        "Main Menu 4", // Image for dayCounter == 4
        "Main Menu 5", // Image for dayCounter == 5
        "Main Menu 6", // Image for dayCounter == 6
        "Main Menu 7"  // Image for dayCounter == 7
    ]
    
    var body: some View {
        ZStack {
            Image(images[min(dayCounter, images.count - 1)])
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
            TodayQuestView(presentationMode: $showTodayQuest, dayCounter: $dayCounter) // Binding `dayCounter` here
                .background(Color(red: 1, green: 0.96, blue: 0.95))
                .presentationDetents([.fraction(0.10), .fraction(0.60)])
                .interactiveDismissDisabled(true)
        }
        .onAppear {
//            print("parner: " ,partnerID!)
            showTodayQuest = true
            print ("Day Counter:", dayCounter)
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
    @Binding var dayCounter: Int // Receive `dayCounter` as a binding
    @State private var dragOffset: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Today's Quest")
                    .font(.custom("Mali-Bold", size: 24))
                    .padding(.top, 20)
                
                DailyQuestView(dayCounter: $dayCounter) // Pass `dayCounter` as a binding
                    .opacity(dragOffset < geometry.size.height / 4 ? 1 : 0)
                
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
                
                Text("This Week’s Quest")
                    .font(.custom("Mali-Bold", size: 24))
                
                WeeklyQuestView(quest: "Your weekly quest here", dayCounter: $dayCounter)
                    .padding(.bottom, 50)
                
                Spacer()
            }
            .background(Color(red: 1, green: 0.96, blue: 0.95))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.height
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
