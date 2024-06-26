//
//  LogModel.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 26/06/24.
//

import Foundation

struct reqLog: Codable {
    var month: Int = 0
    var year: Int = 2024
}

struct LogResponse: Decodable {
    let message: String
    let result: [Log]?
}

class Log: ObservableObject, Codable, Identifiable {
    @Published var _id: String
    @Published var assignUser: [String]
    @Published var isCompleted: Bool
    @Published var type: String
    @Published var description: String
    @Published var dateQuest: String
    @Published var __v: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, assignUser, isCompleted, type, description, dateQuest, __v
    }
    
    init(_id: String = "", assignUser: [String] = [], isCompleted: Bool = false, type: String = "DAILY", description: String = "", dateQuest: String = "", __v: Int = 0) {
        self._id = _id
        self.assignUser = assignUser
        self.isCompleted = isCompleted
        self.type = type
        self.description = description
        self.dateQuest = dateQuest
        self.__v = __v
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _id = try container.decode(String.self, forKey: ._id)
        assignUser = try container.decode([String].self, forKey: .assignUser)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decode(String.self, forKey: .description)
        dateQuest = try container.decode(String.self, forKey: .dateQuest)
        __v = try container.decode(Int.self, forKey: .__v)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(_id, forKey: ._id)
        try container.encode(assignUser, forKey: .assignUser)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(type, forKey: .type)
        try container.encode(description, forKey: .description)
        try container.encode(dateQuest, forKey: .dateQuest)
        try container.encode(__v, forKey: .__v)
    }
}
