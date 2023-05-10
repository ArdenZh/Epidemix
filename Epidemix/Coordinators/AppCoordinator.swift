//
//  AppCoordinator.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    
    private lazy var settingsAssembly = SettingsAssembly()
    private lazy var simulationAssembly = SimulationAssembly()
    private lazy var navController: UINavigationController = UINavigationController()
    
    // При запуске приложения соибраем и показываем экран с настройками
    func start() -> UIViewController {
        let vc = settingsAssembly.makeSettingsModule(navigator: self)
        navController = UINavigationController(rootViewController: vc)
        return navController
    }
    
    // MARK: - Navigation

    private func openSimulation(with settings: SettingsModel) {
        let vc = simulationAssembly.makeSumulationModule(with: settings, navigator: self)
        navController.pushViewController(vc, animated: true)
    }
    
    // Показываем alert когда симуляция завершена
    private func showFinishSimulationAlert() {
        let alert = UIAlertController(title: "All people are infected", message: "Do you want to start over?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) {[weak self] action in
            self?.navController.popViewController(animated: true)
        }
        let noAction = UIAlertAction(title: "No", style: .default)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        navController.present(alert, animated: true)
    }
}

extension AppCoordinator: SettingsNavigator {
    func openSimilation(with settings: SettingsModel) {
        openSimulation(with: settings)
    }
}

extension AppCoordinator: SimulationNavigator {
    func showFinishAlert() {
        showFinishSimulationAlert()
    }
}
