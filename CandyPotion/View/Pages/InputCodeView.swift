//
//  InputCodeView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 20/06/24.
//

import SwiftUI

struct InputCodeView: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    @State private var code: [String] = ["", "", "", ""]
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var token = UserDefaults.standard.value(forKey: "token")
    private var person = UserDefaults.standard.person(forKey: "person")
    private var invitationCode = UserDefaults.standard.person(forKey: "person")?.invitationCode
    private var id = UserDefaults.standard.person(forKey: "person")?._id
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            Color(.purpleCandy).ignoresSafeArea()
            Image("background").resizable().opacity(0.5).ignoresSafeArea()
            
            VStack {
                Image("logo").resizable().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                
                Text("Candylabs is made for two")
                    .font(
                        Font.custom("Mali", size: 32)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                    .frame(width: 296, height: 92, alignment: .top)
                
                Text("Link your account to your partner’s \naccount to start your journey")
                    .font(
                        Font.custom("Mali", size: 15)
                            .weight(.medium)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                    .padding(.bottom)
                
                Spacer().frame(height: 30)
                
                Text("Insert your partner’s code")
                    .font(
                        Font.custom("Mali", size: 18)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                    .padding(.bottom)
                
                HStack {
                    ForEach(0 ..< 4, id: \.self) { index in
                        TextField("", text: $code[index])
                            .frame(width: 70, height: 82)
                            .multilineTextAlignment(.center)
                            .font(.largeTitle)
                            .keyboardType(.numberPad)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .focused($focusedField, equals: index)
                            .onChange(of: code[index]) { _, newValue in
                                if newValue.count > 1 {
                                    code[index] = String(newValue.prefix(1))
                                }
                                if newValue.count == 1 {
                                    if index < 3 {
                                        focusedField = index + 1
                                    } else {
                                        focusedField = nil
                                        verifyCode()
                                    }
                                } else if newValue.isEmpty {
                                    if index > 0 {
                                        focusedField = index - 1
                                    }
                                }
                                
                                if code.joined().count == 4 {
                                    let enteredCode = code.joined()
                                    if enteredCode == invitationCode {
                                        alertMessage = "You can't add yourself as a partner"
                                        showAlert = true
                                    } else {
                                        alertMessage = "Invalid code"
                                        showAlert = true
                                    }
                                }
                            }

                            .onChange(of: code[index]) { _, newValue in
                                code[index] = newValue.uppercased()
                            }
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    focusedField = 0
                }
                .padding(.bottom)

                
                HStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 138, height: 4)
                        .background(.white)
                        .cornerRadius(20)
                    Text("or").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center).foregroundColor(.white)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 138, height: 4)
                        .background(.white)
                        .cornerRadius(20)
                }
                .padding(.bottom)

                
                Text("Invite your partner with code:")
                    .font(
                        Font.custom("Mali", size: 18)
                            .weight(.bold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))

                Text("\(invitationCode ?? "AAAA")").font(
                    Font.custom("Mali", size: 36)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onReceive(timer) { _ in
                person?.getAccount(token: self.token as! String) { success in
                    if success {
                        UserDefaults.standard.setPerson(self.person!, forKey: "person")
                        UserDefaults.standard.set(self.person!.partnerID, forKey: "partnerID")
                    } else {
                        self.alertMessage = "Failed to fetch account details"
                        self.showAlert = true
                    }
                }
            }
        }
    }
    
    func verifyCode() {
        guard code.allSatisfy({ !$0.isEmpty }) else {
            alertMessage = "Please enter the complete verification code"
            showAlert = true
            return
        }
        
        let enteredCode = code.joined()
        let inputCode = CodeRequest(inputCode: enteredCode)
        guard let url = URL(string: "\(APITest)/account/updateAccount/\(id ?? "")") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(inputCode)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.alertMessage = "No data received"
                        self.showAlert = true
                    }
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(CodeResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        if let message = decodedResponse.message {
                            self.alertMessage = message
                            self.showAlert = true
                        } else if let accountResponse = decodedResponse.result {
                            print(accountResponse)
                            person?.getAccount(token: self.token as! String) { success in
                                if success {
                                    UserDefaults.standard.setPerson(self.person!, forKey: "person")
                                    UserDefaults.standard.set(self.person!.partnerID, forKey: "partnerID")
                                } else {
                                    self.alertMessage = "Failed to fetch account details"
                                    self.showAlert = true
                                }
                            }
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.alertMessage = "Error decoding response: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                }
            }.resume()
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = "Failed to encode feedback"
                self.showAlert = true
            }
        }
    }
}

struct CodeRequest: Codable {
    var inputCode: String
}

struct CodeResponse: Decodable {
    var message: String? // Failed only
    var messages: String? // Succeed only
    var result: AccountResponse? // Succeed only
}

#Preview {
    InputCodeView()
}
