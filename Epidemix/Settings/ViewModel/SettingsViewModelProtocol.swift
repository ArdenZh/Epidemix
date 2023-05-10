//
//  SettingsViewModelProtocol.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import Foundation
import Combine

struct SettingsViewModelInput {
    let peopleNumber: AnyPublisher<Int, Never>
    let infectionsNumber: AnyPublisher<Int, Never>
    let infectionPeriod: AnyPublisher<Int, Never>
    let startSimulation: AnyPublisher<Void, Never>
}

protocol SettingsViewModelProtocol {
    func setInput(input: SettingsViewModelInput)
}
