//
//  SimulationCellModel.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 07.05.2023.
//

import Foundation

enum PersonType {
    case healthy
    case infected
}

struct PersonModel {
    let id: UUID = UUID()
    var personType: PersonType = .healthy
}

extension PersonModel: Hashable {
    static func == (lhs: PersonModel, rhs: PersonModel) -> Bool {
        return lhs.id == rhs.id && lhs.personType == rhs.personType
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
