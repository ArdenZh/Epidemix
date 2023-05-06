//
//  AppCoordinator.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import UIKit

class AppCoordinator: Coordinator {

//    let serviceAssembly = ServiceAssembly()
    
    private lazy var settingsAssembly = SettingsAssembly()
    private lazy var simulationAssembly = SimulationAssembly()
    
    private lazy var navController: UINavigationController = UINavigationController()
    
    func start() -> UIViewController {
        let vc = settingsAssembly.makeSettingsModule(navigator: self)
        navController = UINavigationController(rootViewController: vc)
        return navController
    }
    
    // MARK: - Navigation

    private func openSimulation(with settings: SettingsModel) {
        let vc = simulationAssembly.makeSumulationModule(with: settings)
        navController.present(vc, animated: true)
    }
}

extension AppCoordinator: SettingsNavigator {
    func moduleWantsToOpenSimilation(with settings: SettingsModel) {
        openSimulation(with: settings)
    }
}
