//
//  SettingsViewModel.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import Foundation
import Combine

final class SettingsViewModel: SettingsViewModelProtocol {
    
    private weak var navigator: SettingsNavigator?
    private lazy var cancellables: [AnyCancellable] = []
    private lazy var peopleNumber: Int = 10
    private lazy var infectionsNumber: Int = 1
    private lazy var infectionPeriod: Int = 1
    
    init(navigator: SettingsNavigator) {
        self.navigator = navigator
    }
    
    func setInput(input: SettingsViewModelInput) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.peopleNumber
            .sink(receiveValue: {[weak self] value in self?.peopleNumber = value})
            .store(in: &cancellables)
        
        input.infectionsNumber
            .sink(receiveValue: {[weak self] value in self?.infectionsNumber = value})
            .store(in: &cancellables)
        
        input.infectionPeriod
            .sink(receiveValue: {[weak self] value in self?.infectionPeriod = value})
            .store(in: &cancellables)
        
        input.startSimulation
            .sink(receiveValue: {[weak self] Void in
                guard let self = self else {return}
                let settingsModel = SettingsModel(peopleNumber: self.peopleNumber,
                                                  contactsNumber: self.infectionsNumber,
                                                  infectionPeriod: self.infectionPeriod)
                self.navigator?.openSimilation(with: settingsModel)
            })
            .store(in: &cancellables)
    }
}
