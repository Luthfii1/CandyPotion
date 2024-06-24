//
//  Person.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 17/06/24.
//

import Foundation

class PersonModel: Identifiable, ObservableObject, Codable {
    @Published var _id: String
    @Published var name: String
    @Published var email: String
    @Published var dateCreated: String
    @Published var partnerID: String
    @Published var gender: GENDER
    @Published var loveLanguage: LOVELANGUAGE
    @Published var invitationCode: String

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

    enum CodingKeys: String, CodingKey {
        case _id, name, email, dateCreated, partnerID, gender, loveLanguage, invitationCode
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(String.self, forKey: ._id)
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.dateCreated = try container.decode(String.self, forKey: .dateCreated)
        self.partnerID = try container.decode(String.self, forKey: .partnerID)
        self.gender = try container.decode(GENDER.self, forKey: .gender)
        self.loveLanguage = try container.decode(LOVELANGUAGE.self, forKey: .loveLanguage)
        self.invitationCode = try container.decode(String.self, forKey: .invitationCode)
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

    func getAccount(token: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://mc2-be.vercel.app/account/getAccount") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }

            guard let data = data else {
                print("no data received")
                completion(false)
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(AccountResponse.self, from: data)
                DispatchQueue.main.async {
                    self.name = decodedResponse.name ?? ""
                    self.email = decodedResponse.email ?? ""
                    self.dateCreated = decodedResponse.dateCreated ?? ""
                    self.partnerID = decodedResponse.partnerID ?? ""
                    self.gender = GENDER(rawValue: decodedResponse.gender?.uppercased() ?? "UNKNOWN") ?? .UNKNOWN
                    self.loveLanguage = LOVELANGUAGE(rawValue: decodedResponse.loveLanguage?.uppercased() ?? "UNKNOWN") ?? .UNKNOWN
                    self.invitationCode = decodedResponse.invitationCode ?? ""
                    self._id = decodedResponse._id ?? ""
                    print(decodedResponse)
                    completion(true)
                }
            } catch {
                print(error)
                completion(false)
            }
        }.resume()

        UserDefaults.standard.setPerson(self, forKey: "person")
    }
}


extension UserDefaults {
    func setPerson(_ person: PersonModel, forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(person)
            set(data, forKey: key)
        } catch {
            print("Failed to encode PersonModel: \(error)")
        }
    }

    func person(forKey key: String) -> PersonModel? {
        guard let data = data(forKey: key) else { return nil }
        do {
            let decoder = JSONDecoder()
            let person = try decoder.decode(PersonModel.self, from: data)
            return person
        } catch {
            print("Failed to decode PersonModel: \(error)")
            return nil
        }
    }
}
