import SwiftUI

struct CandyBoxView: View {
    @State private var showTodayQuest = false
    @State private var showTabBar = true
    @State private var dayCounter = 0
    @State private var selectedTab: Int = 0
    @State private var defaultHeight: CGFloat = 0.8
    @State private var isDragging : Bool = false
    @State private var offsetVal = 700
    
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
                    .background(.red)
                    .cornerRadius(8)
            })

                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            Capsule()
                                .frame(width: 80, height: 10, alignment: .center)
                                .foregroundStyle(.gray)
                                .padding(.top, 20)
                            
                            Text("Today's Quest")
                                .font(.custom("Mali-Bold", size: 24))
                            
                            Button(action: {
                                logout()
                            }, label: {
                                Text("Logout")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(8)
                            })
                            
                            DailyQuestView(dayCounter: $dayCounter)
                            Text("This Week’s Quest")
                                .font(.custom("Mali-Bold", size: 24))
                                .offset(y: -300)
                            
                            WeeklyQuestView(quest: "Your weekly quest here", dayCounter: $dayCounter)
                                .offset(y: -300)
                            
                            
                        }
                        .background(Color(red: 1, green: 0.96, blue: 0.95))
                        .frame(width: 393, height: 800, alignment: .center)
                        .offset(y: CGFloat(offsetVal))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    print(value.translation.height)
                                    if (value.translation.height < -12)  {
                                        defaultHeight = 0.3
                                        offsetVal = 300
                                    }
                                    
                                    if (value.translation.height > 12) {
                                        defaultHeight = 0.8
                                        offsetVal = 700
                                    }
                                }
                           
                        )
                    }
                }
            
        }
        .onAppear {
            showTodayQuest = true
            print("Day Counter:", dayCounter)
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


#Preview {
    CandyBoxView()
}
