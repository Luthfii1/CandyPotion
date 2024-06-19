//
//  BadgeModel.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 19/06/24.
//

import Foundation

class BadgeModel: Identifiable, ObservableObject {
    var _id: String
    var title: String
    var description: String
    var userID: String
    
    init(title: String, description: String, userID: String, _id: String) {
        self.title = title
        self.description = description
        self.userID = userID
        self._id = _id
    }
}
