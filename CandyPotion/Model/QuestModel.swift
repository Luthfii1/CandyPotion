//
//  QuestModel.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 19/06/24.
//

import Foundation

class QuestModel: Identifiable, ObservableObject {
    var _id: String
    var assignedUser: String
    var dateQuest: String
    var isCompleted: Bool
    var type: QUESTTYPE
    var description: String
    
    init(assignedUser: String, dateQuest: String, isCompleted: Bool, type: QUESTTYPE, description: String, _id: String) {
        self.assignedUser = assignedUser
        self.dateQuest = dateQuest
        self.isCompleted = isCompleted
        self.type = type
        self.description = description
        self._id = _id
    }
}

enum QUESTTYPE: String {
    case DAILY, COUPLE, EVENT
}
