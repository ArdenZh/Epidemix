//
//  SettingsNavigator.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import Foundation

protocol SettingsNavigator: AnyObject {
    func moduleWantsToOpenSimilation(with settings: SettingsModel)
}
