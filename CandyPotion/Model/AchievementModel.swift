//
//  AchievementModel.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 19/06/24.
//

import Foundation

class AchievementModel: Identifiable, ObservableObject {
    var _id: String
    var title: String
    var description: String
    
    init(title: String, description: String, _id: String) {
        self.title = title
        self.description = description
        self._id = _id
    }
}
