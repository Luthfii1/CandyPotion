//
//  AchievementViewModel.swift
//  CandyPotion
//
//  Created by Alifiyah Ariandri on 26/06/24.
//

import Foundation

class AchievementViewModel: ObservableObject {
    var achievements: PerMonth?
    @Published var achievementList: [[String]]?
    @Published var quantityList: [[Int]]?
    @Published var monthList: [[String]]?
    
    func fetchAchievements() {
        guard let url = URL(string: "https://mc2-be.vercel.app/log/getAchievements/6673d82451b11d7a295032d7") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching quests: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(AchievementsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.achievements = decodedResponse.result

                    self.achievementList = self.processData()
                    self.quantityList = self.processDataQty()
                    self.monthList = self.processMonthList()
                    print(self.achievements!)
                }
            } catch {
                print("Error decoding response fetch quest: \(error)")
            }
        }.resume()
    }

    func processData() -> [[String]] {
        // Initialize the test array with 4 sub-arrays, each containing 4 empty strings
        var perQuarter = Array(repeating: Array(repeating: "", count: 4), count: 4)

        guard let achievements = achievements else { return perQuarter }

        let mirror = Mirror(reflecting: achievements)

        var indexMonth = 0

        for child in mirror.children {
            if let value = child.value as? PerMonthDetail {
                let row = indexMonth / 4
                let column = indexMonth % 4

                perQuarter[row][column] = value.category ?? ""
            }

            indexMonth += 1
            if indexMonth == getCurrentMonth() - 1 {
                break
            }
        }

        print(perQuarter)
        return perQuarter
    }

    func processDataQty() -> [[Int]] {
        // Initialize the test array with 4 sub-arrays, each containing 4 empty strings
        var perQuarter = Array(repeating: Array(repeating: -1, count: 4), count: 4)

        guard let achievements = achievements else { return perQuarter }

        let mirror = Mirror(reflecting: achievements)

        var indexMonth = 0

        for child in mirror.children {
            if let value = child.value as? PerMonthDetail {
                let row = indexMonth / 4
                let column = indexMonth % 4

                perQuarter[row][column] = value.quantity ?? -1
            }

            indexMonth += 1
            if indexMonth == getCurrentMonth() - 1 {
                break
            }
        }

        print(perQuarter)
        return perQuarter
    }
    
    func processMonthList() -> [[String]] {
        // Initialize the test array with 4 sub-arrays, each containing 4 empty strings
        var perQuarter = Array(repeating: Array(repeating: "", count: 4), count: 4)

        guard let achievements = achievements else { return perQuarter }

        let mirror = Mirror(reflecting: achievements)

        var indexMonth = 0

        for child in mirror.children {
            if let value = child.label as? String {
                let row = indexMonth / 4
                let column = indexMonth % 4

                perQuarter[row][column] = value
            }

            indexMonth += 1
            if indexMonth == getCurrentMonth() - 1 {
                break
            }
        }

        print(perQuarter)
        return perQuarter
    }

    func getCurrentMonth() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        return month
    }
}

struct AchievementsResponse: Decodable {
    let message: String
    let result: PerMonth
}

struct PerMonth: Decodable {
    let January: PerMonthDetail?
    let February: PerMonthDetail?
    let March: PerMonthDetail?
    let April: PerMonthDetail?
    let May: PerMonthDetail?
    let June: PerMonthDetail?
    let July: PerMonthDetail?
    let August: PerMonthDetail?
    let September: PerMonthDetail?
    let October: PerMonthDetail?
    let November: PerMonthDetail?
    let December: PerMonthDetail?
}

struct PerMonthDetail: Decodable {
    let category: String?
    let quantity: Int?
}

struct MonthRequest: Codable {
    let month: Int?
    let year: Int?
}

struct MonthResponse: Decodable {
    let message: String
    let result: [MonthResponseDetail]?
}

struct MonthResponseDetail: Decodable {
    let assignUser: String?
    let isCompleted: String?
    let type: String?
    let description: String?
    let _id: String?
    let dateQuest: String?
}
