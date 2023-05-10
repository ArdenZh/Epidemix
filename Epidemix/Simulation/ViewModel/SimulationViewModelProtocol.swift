//
//  SimulationViewModelProtocol.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import Foundation
import Combine

protocol SimulationViewModelInput{
    func personDidSelect(at index: Int)
    func zoom(increase: Bool)
}

protocol SimulationViewModelOuput {
    var personModels: Published<[PersonModel]>.Publisher { get }
    var infectedProgress: Published<Float>.Publisher { get }
    var infectedProgressString: Published<String>.Publisher { get }
    var numberOfColumns: Published<Int>.Publisher { get }
}

protocol SimulationViewModelProtocol: SimulationViewModelOuput, SimulationViewModelInput {}
