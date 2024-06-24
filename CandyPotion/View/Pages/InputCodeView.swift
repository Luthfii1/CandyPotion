//
//  InputCodeView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 20/06/24.
//

import SwiftUI

import SwiftUI

struct InputCodeView: View {
    @EnvironmentObject private var getAccountVM: GetAccountVM
    @EnvironmentObject private var inputCodeVM: InputCodeVM
    @FocusState private var focusedField: Int?
    
    var body: some View {
        ZStack {
            backgroundView
            VStack {
                logoView
                titleView
                Spacer().frame(height: 30)
                instructionView
                codeInputFields
                Spacer().frame(height: 30)
                orView
                invitePartnerView
            }
            .alert(isPresented: $inputCodeVM.condition.showAlert) {
                Alert(title: Text("Message"), message: Text(inputCodeVM.condition.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear{
            inputCodeVM.getAccount()
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            Color(.purpleCandy)
                .ignoresSafeArea()
            Image("background")
                .resizable()
                .opacity(0.5)
                .ignoresSafeArea()
        }
    }
    
    private var logoView: some View {
        Image("logo").resizable().frame(width: 100, height: 100)
    }
    
    private var titleView: some View {
        VStack {
            Text("Candylabs is made for two")
                .font(Font.custom("Mali", size: 32).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                .frame(width: 296, height: 92, alignment: .top)
            
            Text("Link your account to your partner’s \naccount to start your journey")
                .font(Font.custom("Mali", size: 15).weight(.medium))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                .padding(.bottom)
        }
    }
    
    private var instructionView: some View {
        Text("Insert your partner’s code")
            .font(Font.custom("Mali", size: 18).weight(.bold))
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
            .padding(.bottom)
    }
    
    private var codeInputFields: some View {
        HStack {
            ForEach(0 ..< 4, id: \.self) { index in
                TextField("", text: $inputCodeVM.code[index])
                    .frame(width: 70, height: 82)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .keyboardType(.numberPad)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .font(.custom("Mali-Regular", size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .focused($focusedField, equals: index)
                    .onChange(of: inputCodeVM.code[index]) { oldValue, newValue in
                        handleCodeChange(at: index, newValue: newValue)
                    }
            }
        }
        .padding(.horizontal)
        .onAppear {
            focusedField = 0
        }
        .padding(.bottom)
    }
    
    private var orView: some View {
        HStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 138, height: 4)
                .background(.white)
                .cornerRadius(20)
            Text("or")
                .font(.custom("Mali-Regular", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 138, height: 4)
                .background(.white)
                .cornerRadius(20)
        }
        .padding(.bottom)
    }
    
    private var invitePartnerView: some View {
        VStack {
            Text("Invite your partner with code:")
                .font(Font.custom("Mali", size: 18).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
            
            Text("\(UserDefaults.standard.string(forKey: "invitationCode") ?? "ERROR")")
                .font(Font.custom("Mali", size: 36).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
        }
    }
    
    private func handleCodeChange(at index: Int, newValue: String) {
        if newValue.count > 1 {
            inputCodeVM.code[index] = String(newValue.prefix(1))
        }
        if newValue.count == 1 {
            if index < 3 {
                focusedField = index + 1
            } else {
                focusedField = nil
                inputCodeVM.verifyCode()
            }
        } else if newValue.isEmpty {
            if index > 0 {
                focusedField = index - 1
            }
        }
        
        if inputCodeVM.code.joined().count == 4 {
            let enteredCode = inputCodeVM.code.joined()
            if enteredCode == UserDefaults.standard.string(forKey: "invitationCode") {
                inputCodeVM.condition.alertMessage = "You can't add yourself as a partner"
                inputCodeVM.condition.showAlert = true
            } else {
                print("success add partner")
//                inputCodeVM.condition.alertMessage = "Success add partner"
//                inputCodeVM.condition.showAlert = true
            }
        }
    }
}

#Preview {
    InputCodeView()
        .environmentObject(InputCodeVM())
        .environmentObject(GetAccountVM())
}
