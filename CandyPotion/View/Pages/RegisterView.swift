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
        NavigationStack {
            ZStack {
                Color(.purpleCandy).ignoresSafeArea()
                Image("background").resizable().opacity(0.5).ignoresSafeArea()
                VStack {
                    Text("Let us know you!")
                        .font(
                            Font.custom("Mali-Bold", size: 32)
                                .weight(.bold)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                            HStack {
                                TextField("Name", text: $registerVM.input.name)
                                    .font(.custom("Mali-Regular", size: 18))
                                    .padding(.horizontal)
                            }
                            .frame(width: 329)
                        }
                        
                        Spacer().frame(height: 12)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                            HStack {
                                TextField("Email", text: $registerVM.input.email)
                                    .autocapitalization(.none)
                                    .font(.custom("Mali-Regular", size: 18))
                                    .padding(.horizontal)
                            }
                            .frame(width: 329)
                        }

                        Spacer().frame(height: 12)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                            HStack {
                                SecureField("Password", text: $registerVM.input.password)
                                    .autocapitalization(.none)
                                    .font(.custom("Mali-Regular", size: 18))
                                    .padding(.horizontal)
                            }
                            .frame(width: 329)
                        }

                        Spacer().frame(height: 12)
                        
                        Picker("Gender", selection: $registerVM.input.gender) {
                            ForEach(GENDER.allCases, id: \.self) { gender in
                                Text(gender.rawValue.capitalized)
                                    .tag(gender)
                                    .foregroundColor(registerVM.input.gender == gender ? .white : .primary) 
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
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 329, height: 51)
                                .background(registerVM.condition.isLoading ? .gray : Color(red: 0.56, green: 0.4, blue: 0.78))
                                .cornerRadius(12)
                            Text("Sign Up")
                                .font(
                                    Font.custom("Mali", size: 24)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(registerVM.condition.isLoading)
                    
                    HStack {
                        Text("Already have an account?").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.81))
                        Button("Log In") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                        .foregroundColor(.white).underline()
                    }
                }
                .alert(isPresented: $registerVM.condition.showAlert) {
                    Alert(title: Text("Failed to Register"), message: Text(registerVM.condition.alertMessage), dismissButton: .default(Text("OK")))
                }
                
                if registerVM.condition.isLoading {
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
        .onChange(of: registerVM.condition.isFinished) { _, isFinished in
            if isFinished {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    RegisterView()
}
