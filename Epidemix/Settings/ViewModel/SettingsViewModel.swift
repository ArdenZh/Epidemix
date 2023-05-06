//
//  SettingsViewModel.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import Foundation

final class SettingsViewModel: SettingsViewModelProtocol {
    
    private weak var navigator: SettingsNavigator?
    
    init(navigator: SettingsNavigator) {
        self.navigator = navigator
    }
    
    
    
}
