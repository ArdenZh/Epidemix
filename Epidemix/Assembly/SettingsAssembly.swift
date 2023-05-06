//
//  SettingsAssembly.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import UIKit

final class SettingsAssembly {
    
    func makeSettingsModule(navigator: SettingsNavigator) -> UIViewController {
        let viewModel = SettingsViewModel(navigator: navigator)
        let settingsViewController = SettingsViewController(viewModel: viewModel)
        return settingsViewController
    }
}
