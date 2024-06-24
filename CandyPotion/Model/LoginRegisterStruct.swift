//
//  LoginModel.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 24/06/24.
//

import Foundation

struct InputLogin: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Decodable {
    let message: String
    let result: String?
}

struct AccountResponse: Decodable {
    var _id: String?
    var name: String?
    var email: String?
    var dateCreated: String?
    var password: String?
    var partnerID: String?
    var gender: String?
    var loveLanguage: String?
    var invitationCode: String?
}

struct InputRegister: Codable {
    var name : String = ""
    var email : String = ""
    var password : String = ""
    var gender : GENDER = .UNKNOWN
}

struct RegisterResponse: Decodable {
    let message: String
    let result: AccountResponse?
}

struct Conditions {
    var showAlert : Bool = false
    var alertMessage : String = ""
    var isLoading: Bool = false
    var isFinished: Bool = false
}
