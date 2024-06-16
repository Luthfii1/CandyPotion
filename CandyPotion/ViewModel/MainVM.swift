//
//  MainVM.swift
//  CandyPotion
//
//  Created by Luthfi Misbachul Munir on 17/06/24.
//

import Foundation

class MainVM: ObservableObject {
    @Published var Person: PersonModel

    init(Person: PersonModel) {
        self.Person = Person
    }
}
