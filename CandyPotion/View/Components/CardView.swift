// CardView.swift
import SwiftUI

struct CardView: View {
    let quest: String
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isChecked: Bool = false
    
    var body: some View {
            
            
            VStack {
                HStack{
                    Circle()
                        .frame(width: 86, height: 86, alignment: .leading)
                        .padding(.leading, 10)
                    
                    
                        
                    
                    VStack(alignment: .leading){
                        Text(quest).font(Font.custom("Mali-Bold", size: 14))
                            .foregroundColor(.black)

                        ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 78, height: 22, alignment: .leading)
                                .background(isChecked ? Color(red: 0.71, green: 0.95, blue: 0.75) : Color(red: 0.79, green: 0.77, blue: 0.81))
                                .cornerRadius(7)
                            
                            Text(isChecked ? "Done" : "20h left").font(Font.custom("Mali-Bold", size: 12))
                                .foregroundColor(.black)
                        }
                    }
                    
                    
                    Button(action: {
                        updateQuest(isCompleted: true)
                        self.isChecked = true
                    }) {
                        Image(isChecked ? "Check Done" : "Check")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56, height: 56, alignment: .center)
                            .padding(.trailing, 10)
                    }
                    .disabled(isChecked)
                    
                    
                    
                }
                
            }
            .frame(width: 361, height: 113)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isChecked ? Color(red: 0.23, green: 0.8, blue: 0.22) : Color(red: 0.31, green: 0.12, blue: 0.24), lineWidth: 3)
            )
            .padding()
        
    }
    
//https://mc2-be.vercel.app/log/updateQuest/6675010198feecc0c9ed4b19
    
    func updateQuest(isCompleted: Bool) {
        guard let url = URL(string: "") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let update = QuestUpdate(isCompleted: isCompleted)
        
        do {
            let jsonData = try JSONEncoder().encode(update)
            request.httpBody = jsonData
            print("jsondata: ", jsonData)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to update quest: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }
                
                guard let data = data else {
                    print("no data received")
                    return
                }
                
                print("data: ", data)
                
                DispatchQueue.main.async {
                    self.alertMessage = "Quest updated successfully!"
                    self.showAlert = true
                    print("Success!")
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Failed to encode update"
                self.showAlert = true
            }
        }
    }
}

struct QuestUpdate: Codable {
    let isCompleted: Bool
}

struct Result: Decodable {
    let assignUser: [String]
    let isCompleted: Bool
    let type: String
    let description: String
    let _id: String
    let dateQuest: String
    let __v: Int
}

#Preview {
    CardView(quest: "Write a heartfelt love letter to your partner.")
}
