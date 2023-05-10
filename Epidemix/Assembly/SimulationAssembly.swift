//
//  Simulation.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import UIKit

final class SimulationAssembly {
    
    //Собираем модуль с симуляцией
    func makeSumulationModule(with settings: SettingsModel, navigator: SimulationNavigator) -> UIViewController {
        let viewModel = SimulationViewModel(settingsnModel: settings, navigator: navigator)
        let simulationViewController = SimulationViewController(viewModel: viewModel)
        return simulationViewController
    }
}
