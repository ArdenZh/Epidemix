//
//  SimulationViewModel.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import Foundation
import Combine

private enum Constants {
    static let minZoom: Int = 3
    static let maxZoom: Int = 6
}

final class SimulationViewModel: SimulationViewModelProtocol {
    
    //MARK: - Properties
    
    private weak var navigator: SimulationNavigator?
    private let settingsnModel: SettingsModel
    private var cancellables: [AnyCancellable] = []
    private var timer: Timer?
    private var infectedNumber = 0 {
        didSet {
            updateInfectedProgress()
        }
    }
    
    @Published private var wrappedModels: [PersonModel] = []
    @Published private var wrappedInfectedProgress: Float = Float()
    @Published private var wrappedInfectedProgressString: String = String()
    @Published private var wrappedNumberOfColumns: Int = 3
    
    //MARK: - Output
    
    var personModels: Published<[PersonModel]>.Publisher { $wrappedModels }
    var infectedProgress: Published<Float>.Publisher { $wrappedInfectedProgress }
    var infectedProgressString: Published<String>.Publisher { $wrappedInfectedProgressString }
    var numberOfColumns: Published<Int>.Publisher { $wrappedNumberOfColumns }
    
    //MARK: - Init / Deinit
    
    init(settingsnModel: SettingsModel, navigator: SimulationNavigator) {
        self.settingsnModel = settingsnModel
        self.navigator = navigator
        for _ in 0..<settingsnModel.peopleNumber {
            self.wrappedModels.append(PersonModel())
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    //MARK: - Input
    
    func personDidSelect(at index: Int) {
        if infectedNumber == 0 {
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(settingsnModel.infectionPeriod),
                                         target: self,
                                         selector: #selector(infectedCalculation),
                                         userInfo: nil,
                                         repeats: true)
        }
        wrappedModels[index].personType = .infected
        infectedNumber += 1
    }
    
    func zoom(increase: Bool) {
        if increase {
            if wrappedNumberOfColumns > Constants.minZoom {
                wrappedNumberOfColumns -= 1
            }
        } else {
            if wrappedNumberOfColumns < Constants.maxZoom {
                wrappedNumberOfColumns += 1
            }
        }
    }
    
    //MARK: - Calculation of infected
    
    @objc
    private func infectedCalculation() {
        var newInfectedIndexes = [Int]()
        // Уводим вычисление с главного потока
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {return}
            // Вычисляем индексы новых зараженных
            newInfectedIndexes.append(contentsOf: self.calculateTargetIndices(for: self.wrappedModels))
            for index in newInfectedIndexes {
                self.wrappedModels[index].personType = .infected
            }
            self.infectedNumber += newInfectedIndexes.count
            // Когда все люди заражены, выключаем таймер и показываем alert
            if self.infectedNumber == self.wrappedModels.count {
                self.timer?.invalidate()
                self.timer = nil
                DispatchQueue.main.async {
                    self.navigator?.showFinishAlert()
                }
            }
        }
    }
    
    private func getAllHealthyIndices() -> [Int] {
        var result: [Int] = []
        for i in 0..<wrappedModels.count {
            if wrappedModels[i].personType == .healthy {
                result.append(i)
            }
        }
        return result
    }
    
    private func calculateTargetIndices(for persons: [PersonModel]) -> [Int] {
        var targetIndices = [Int]()
        var resultIndeces = Set<Int>()
        let numberOfColumns = self.wrappedNumberOfColumns
        let numberOfRows = Int(ceil(Double(settingsnModel.peopleNumber) / Double(numberOfColumns)))
        
        for index in 0..<persons.count {
            let row = index / numberOfColumns
            let column = index % numberOfColumns
            
            if persons[index].personType == .infected {
                // Вычисляем квдрат 3х3 вокруг зараженного, с учетом границ CollectionView
                for i in max(row-1, 0)...min(row+1, numberOfRows-1) {
                    for j in max(column-1, 0)...min(column+1, numberOfColumns-1) {
                        // Для каждого элемента в вычисленном квадрате проверяем здоров ли и не является ли самим элементом
                        if (i * numberOfColumns + j) < persons.count &&
                            persons[i*numberOfColumns+j].personType == .healthy &&
                            !(i == row && j == column){
                            targetIndices.append(i*numberOfColumns+j)
                        }
                    }
                }
                if targetIndices.count > 0 {
                    // Проверяем, что число контактов будет не больше чем число здоровых людей вокруг
                    let maxNuberOfInfected = min(targetIndices.count, settingsnModel.contactsNumber)
                    // Получаем случайное число людей для заражения (может и никого не заразить)
                    let randomNuberOfInfected = Int.random(in: 0...maxNuberOfInfected)
                    // Перемешиваем массив целей для заражения и выбираем оттуда полученное случайное число людей
                    let shuffledTargetIndices = targetIndices.shuffled()
                    let randomTargetIndices = Array(shuffledTargetIndices.prefix(randomNuberOfInfected))
                    randomTargetIndices.forEach {resultIndeces.insert($0)}
                }
            }
        }
        return Array(resultIndeces)
    }
    
    private func updateInfectedProgress() {
        wrappedInfectedProgress = Float(infectedNumber) / Float(wrappedModels.count)
        wrappedInfectedProgressString = "\(infectedNumber) out of \(wrappedModels.count)"
    }
}
