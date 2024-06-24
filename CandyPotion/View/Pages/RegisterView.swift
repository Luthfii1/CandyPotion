//
//  RegisterView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 19/06/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerVM = RegisterVM()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        //        if registerVM.condition.isFinished {
        //            presentationMode.wrappedValue.dismiss()
        //        }
        //
        NavigationStack {
            ZStack {
                VStack {
                    Text("Let me know you")
                    
                    VStack {
                        TextField("Name", text: $registerVM.input.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        TextField("Email", text: $registerVM.input.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $registerVM.input.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        Picker("Gender", selection: $registerVM.input.gender) {
                            ForEach(GENDER.allCases, id: \.self) { gender in
                                Text(gender.rawValue.capitalized).tag(gender)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    }
                    .padding()
                    
                    Button {
                        registerVM.submitFeedback()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                .frame(height: 46)
                                .padding(.horizontal)
                                .foregroundColor(registerVM.condition.isLoading ? .gray : .blue)
                            Text("Register")
                                .foregroundStyle(.white)
                        }
                    }
                    .disabled(registerVM.condition.isLoading)
                    
                    HStack {
                        Text("Already have an account?")
                        Button("Log In") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .alert(isPresented: $registerVM.condition.showAlert) {
                    Alert(title: Text("Failed to Register"), message: Text(registerVM.condition.alertMessage), dismissButton: .default(Text("OK")))
                }
                
                if (registerVM.condition.isLoading) {
                    VStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(2)
                            .padding(.top, 20)
                        
                        Text("Please wait")
                            .padding(.top, 30)
                    }
                    .padding(20)
                    .background(.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: registerVM.condition.isFinished) { oldVal, isFinished in
            if isFinished {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    RegisterView()
}
