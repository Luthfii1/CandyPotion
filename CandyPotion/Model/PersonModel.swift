//
//  Person.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 17/06/24.
//

import Foundation

class PersonModel: Identifiable, ObservableObject {
    var _id: String
    var name: String
    var email: String
    var dateCreated: String
    var partnerID: String
    var gender: GENDER
    var loveLanguage: LOVELANGUAGE
    var invitationCode: String
    
    init(name: String, email: String, dateCreated: String, partnerID: String, gender: GENDER, loveLanguage: LOVELANGUAGE, invitationCode: String, _id: String) {
        self.name = name
        self.email = email
        self.dateCreated = dateCreated
        self.partnerID = partnerID
        self.gender = gender
        self.loveLanguage = loveLanguage
        self.invitationCode = invitationCode
        self._id = _id
    }
}

enum GENDER: String {
    case MALE, FEMALE, UNKNOWN
}

enum LOVELANGUAGE: String {
    case ACTS_OF_SERVICE, WORDS_OF_AFFIRMATION, PHYSICAL_TOUCH, RECEIVING_GIFTS, QUALITY_TIME
}
