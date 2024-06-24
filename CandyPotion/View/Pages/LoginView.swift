//
//  LoginView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 20/06/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var loginVM: LoginVM
    
    var body: some View {
        NavigationStack {
            if loginVM.isLoggedIn {
                InputCodeView()
            } else {
                ZStack {
                    Color(.purpleCandy).ignoresSafeArea()
                    Image("background").resizable().opacity(0.5).ignoresSafeArea()
                    
                    VStack {
                        Image("loginAssets").resizable().frame(width: 257, height: 373).offset(y: 40)
                        Text("Welcome Back!")
                            .font(
                                Font.custom("Mali-Bold", size: 32)
                                    .weight(.bold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Text("Your presence matters,\nget back into Candylabs!")
                            .font(
                                Font.custom("Mali", size: 15)
                                    .weight(.medium)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                            .padding(.bottom)
                        
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                                HStack {
                                    TextField("Email", text: $loginVM.email)
                                        .onChange(of: loginVM.email) { _, newValue in
                                            loginVM.email = newValue.lowercased()
                                        }
                                        .padding(.horizontal)
                                        .autocapitalization(.none)
                                        .font(.custom("Mali-Regular", size: 18))
                                }
                                .frame(width: 329)
                            }
                            Spacer().frame(height: 12)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).frame(width: 329, height: 51).foregroundColor(.white)
                                HStack {
                                    SecureField("Password", text: $loginVM.password)
                                        .padding(.horizontal)
                                        .font(.custom("Mali-Regular", size: 18))
                                }
                                .frame(width: 329)
                            }
                        }
                        
                        Button {
                            loginVM.login()
                        } label: {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 329, height: 51)
                                    .background(Color(red: 0.56, green: 0.4, blue: 0.78))
                                    .cornerRadius(12)
                                Text("Log in")
                                    .font(
                                        Font.custom("Mali", size: 24)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }
                        }
                        .disabled(loginVM.isLoading)
                        .padding(.top, 20)
                        
                        HStack {
                            Text("Do not have an account?").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.79, green: 0.77, blue: 0.81))

                            NavigationLink(destination: RegisterView()) {
                                Text("Register").font(.custom("Mali-Regular", size: 18)).multilineTextAlignment(.center)
                                    .foregroundColor(.white).underline()
                            }
                        }
                    }.offset(y: -20)
                        .alert(isPresented: $loginVM.showAlert) {
                            Alert(title: Text("Failed to Login"), message: Text(loginVM.alertMessage), dismissButton: .default(Text("OK")))
                        }
                    
                    if loginVM.isLoading {
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
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginVM())
}
