//
//  Person.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 23/06/24.
//

import Foundation

enum GENDER: String, Codable, CaseIterable {
    case MALE, FEMALE, UNKNOWN
}

enum LOVELANGUAGE: String, Codable {
    case ACTS_OF_SERVICE, WORDS_OF_AFFIRMATION, PHYSICAL_TOUCH, RECEIVING_GIFTS, QUALITY_TIME, UNKNOWN
}

class PersonModel: ObservableObject, Codable, Identifiable {
    @Published var _id: String
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var gender: GENDER
    @Published var invitationCode: String
    @Published var dateCreated: String
    @Published var partnerID: String?
    @Published var loveLanguage: LOVELANGUAGE?
    @Published var __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, name, email, password, gender, invitationCode, dateCreated, partnerID, loveLanguage, __v
    }
    
    init(_id: String = "", name: String = "", email: String = "", password: String = "", gender: GENDER = .UNKNOWN, invitationCode: String = "", dateCreated: String = "", partnerID: String? = nil, loveLanguage: LOVELANGUAGE = .UNKNOWN, __v: Int = 0) {
        self._id = _id
        self.name = name
        self.email = email
        self.password = password
        self.gender = gender
        self.invitationCode = invitationCode
        self.dateCreated = dateCreated
        self.partnerID = partnerID
        self.loveLanguage = loveLanguage
        self.__v = __v
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password) // If you need to decode password
        gender = try container.decode(GENDER.self, forKey: .gender)
        invitationCode = try container.decode(String.self, forKey: .invitationCode)
        dateCreated = try container.decode(String.self, forKey: .dateCreated)
        partnerID = try container.decodeIfPresent(String.self, forKey: .partnerID)
        loveLanguage = try container.decodeIfPresent(LOVELANGUAGE.self, forKey: .loveLanguage)
        __v = try container.decode(Int.self, forKey: .__v)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password) // If you need to encode password
        try container.encode(gender, forKey: .gender)
        try container.encode(invitationCode, forKey: .invitationCode)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(partnerID, forKey: .partnerID)
        try container.encode(loveLanguage, forKey: .loveLanguage) 
        try container.encode(__v, forKey: .__v)
    }
}

