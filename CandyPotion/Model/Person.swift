//
//  Person.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 23/06/24.
//

import Foundation

enum GENDER: String, Codable {
    case MALE, FEMALE, UNKNOWN
}

enum LOVELANGUAGE: String, Codable {
    case ACTS_OF_SERVICE, WORDS_OF_AFFIRMATION, PHYSICAL_TOUCH, RECEIVING_GIFTS, QUALITY_TIME, UNKNOWN
}

struct InputLogin: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Decodable {
    let messages: String
    let result: String
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

class Person: ObservableObject, Codable, Identifiable {
    @Published var _id: String
    @Published var name: String
    @Published var email: String
    @Published var dateCreated: String
    @Published var partnerID: String
    @Published var gender: GENDER
    @Published var loveLanguage: LOVELANGUAGE
    @Published var invitationCode: String
    
    enum CodingKeys: String, CodingKey {
        case _id, name, email, dateCreated, partnerID, gender, loveLanguage, invitationCode
    }
    
    init(_id: String = "", name: String = "", email: String = "", dateCreated: String = "", partnerID: String = "", gender: GENDER = .UNKNOWN, loveLanguage: LOVELANGUAGE = .UNKNOWN, invitationCode: String = "") {
        self._id = _id
        self.name = name
        self.email = email
        self.dateCreated = dateCreated
        self.partnerID = partnerID
        self.gender = gender
        self.loveLanguage = loveLanguage
        self.invitationCode = invitationCode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        dateCreated = try container.decode(String.self, forKey: .dateCreated)
        partnerID = try container.decode(String.self, forKey: .partnerID)
        gender = try container.decode(GENDER.self, forKey: .gender)
        loveLanguage = try container.decode(LOVELANGUAGE.self, forKey: .loveLanguage)
        invitationCode = try container.decode(String.self, forKey: .invitationCode)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(partnerID, forKey: .partnerID)
        try container.encode(gender, forKey: .gender)
        try container.encode(loveLanguage, forKey: .loveLanguage)
        try container.encode(invitationCode, forKey: .invitationCode)
    }
}
