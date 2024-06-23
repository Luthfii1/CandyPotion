//
//  LoginView.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 20/06/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var loginVM : LoginVM
    
    var body: some View {
        NavigationStack {
            if (loginVM.isLoggedIn) {
                InputCodeView()
            } else {
                ZStack {
                    VStack {
                        Text("Welcome Back!")
                            .padding()
                        
                        VStack {
                            TextField("Email", text: $loginVM.email)
                                .onChange(of: loginVM.email) { oldValue, newValue in
                                    loginVM.email = newValue.lowercased()}
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            
                            SecureField("Password", text: $loginVM.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                        }
                        
                        Button {
                            loginVM.login()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                    .frame(height: 46)
                                    .padding(.horizontal)
                                    .foregroundColor(loginVM.isLoading ? .gray : .blue)
                                Text("Log In")
                                    .foregroundStyle(.white)
                            }
                        }
                        .disabled(loginVM.isLoading)
                        .padding(.top, 20)
                        
                        HStack {
                            Text("Do not have an account?")
                            NavigationLink(destination: RegisterView()) {
                                Text("Register")
                            }
                        }
                        .padding(.top, 20)
                    }
                    .alert(isPresented: $loginVM.showAlert) {
                        Alert(title: Text("Failed to Login"), message: Text(loginVM.alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    if (loginVM.isLoading) {
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
