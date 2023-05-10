//
//  SettingsViewController.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import UIKit
import Combine

private enum Constants {
    static let logoImageName: String = "logo"
    static let logoImageWidth: CGFloat = 100
    static let logoTitle: String = "Epidemix"
    static let peopleTitleLabelText: String = "Number of people"
    static let peopleDescriptionLabelText: String = "Select the number of people to model"
    static let peopleSliderMinimumValue: Float = 10
    static let peopleSliderMaximumValue: Float = 300
    static let infectionsTitleLabelText: String = "Number of infections"
    static let infectionsDescriptionLabelText: String = "Select the number of infections per contact"
    static let infectionsSliderMinimumValue: Float = 1
    static let infectionsSliderMaximumValue: Float = 9
    static let periodTitleLabelText: String = "Infection period"
    static let periodDescriptionLabelText: String = "Select the period of new infections in seconds"
    static let periodSliderMinimumValue: Float = 1
    static let periodSliderMaximumValue: Float = 60
    static let startButtonTitle: String = "Start simulation"
}

final class SettingsViewController: UIViewController {
    
    //MARK: - Properties

    private let viewModel: SettingsViewModelProtocol
    private var cancellables: [AnyCancellable] = []
    private let peopleNumber = PassthroughSubject<Int, Never>()
    private let infectionsNumber = PassthroughSubject<Int, Never>()
    private let infectionPeriod = PassthroughSubject<Int, Never>()
    private let startSimulation = PassthroughSubject<Void, Never>()
    
    //MARK: - Init
    
    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - SetupUI
    
    private lazy var logoImageView: UIImageView = {
        let logoImage = UIImage(named: Constants.logoImageName)
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    private lazy var logoTitleLabel: UILabel = {
        let logoTitleLabel = UILabel()
        logoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        logoTitleLabel.text = Constants.logoTitle
        logoTitleLabel.textColor = .label
        logoTitleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return logoTitleLabel
    }()
    
    private lazy var logoStackView: UIStackView = {
        let logoStackView = UIStackView(arrangedSubviews: [logoImageView, logoTitleLabel])
        logoStackView.translatesAutoresizingMaskIntoConstraints = false
        logoStackView.axis = .horizontal
        logoStackView.distribution = .fillProportionally
        logoStackView.spacing = 16
        return logoStackView
    }()
    
    private lazy var settingsView: UIView = {
        let settingsView = UIView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.backgroundColor = .systemBackground
        settingsView.layer.cornerRadius = 16
        return settingsView
    }()
    
    private lazy var peopleStackView: SettingStackView = {
        let peopleStackView = SettingStackView()
        peopleStackView.titleLabel.text = Constants.peopleTitleLabelText
        peopleStackView.descriptionLabel.text = Constants.peopleDescriptionLabelText
        peopleStackView.numberLabel.text = "\(Int(Constants.peopleSliderMinimumValue))"
        peopleStackView.slider.minimumValue = Constants.peopleSliderMinimumValue
        peopleStackView.slider.maximumValue = Constants.peopleSliderMaximumValue
        peopleStackView.slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return peopleStackView
    }()
    
    private lazy var infectionsStackView: SettingStackView = {
        let infectionsStackView = SettingStackView()
        infectionsStackView.titleLabel.text = Constants.infectionsTitleLabelText
        infectionsStackView.descriptionLabel.text = Constants.infectionsDescriptionLabelText
        infectionsStackView.numberLabel.text = "\(Int(Constants.infectionsSliderMinimumValue))"
        infectionsStackView.slider.minimumValue = Constants.infectionsSliderMinimumValue
        infectionsStackView.slider.maximumValue = Constants.infectionsSliderMaximumValue
        infectionsStackView.slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return infectionsStackView
    }()
    
    private lazy var periodStackView: SettingStackView = {
        let periodStackView = SettingStackView()
        periodStackView.titleLabel.text = Constants.periodTitleLabelText
        periodStackView.descriptionLabel.text = Constants.periodDescriptionLabelText
        periodStackView.numberLabel.text = "\(Int(Constants.periodSliderMinimumValue))"
        periodStackView.slider.minimumValue = Constants.periodSliderMinimumValue
        periodStackView.slider.maximumValue = Constants.periodSliderMaximumValue
        periodStackView.slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return periodStackView
    }()
    
    private lazy var settingsStackView: UIStackView = {
        let settingsStackView = UIStackView(arrangedSubviews: [peopleStackView, infectionsStackView, periodStackView])
        settingsStackView.axis = .vertical
        settingsStackView.spacing = 32
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        settingsStackView.distribution = .equalSpacing
        return settingsStackView
    }()
    
    private lazy var startButton: UIButton = {
        let startButton = UIButton()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle(Constants.startButtonTitle, for: .normal)
        startButton.backgroundColor = .systemBlue
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        startButton.layer.cornerRadius = 16
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        return startButton
    }()
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        addViews()
    }
    
    private func addViews() {
        view.addSubview(logoStackView)
        view.addSubview(settingsView)
        settingsView.addSubview(settingsStackView)
        view.addSubview(startButton)
        constraintViews()
    }
    
    private func constraintViews() {
        NSLayoutConstraint.activate([
            logoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            logoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            logoImageView.widthAnchor.constraint(equalToConstant: Constants.logoImageWidth),
            logoImageView.heightAnchor.constraint(equalToConstant: Constants.logoImageWidth),
            
            settingsView.topAnchor.constraint(equalTo: logoStackView.bottomAnchor, constant: 32),
            settingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            settingsStackView.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 32),
            settingsStackView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 16),
            settingsStackView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -16),
            settingsStackView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -32),
            
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            startButton.topAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: 32)
        ])
    }
    
    //MARK: - Binding
    
    private func bind(to viewModel: SettingsViewModelProtocol) {
        let input = SettingsViewModelInput(peopleNumber: peopleNumber.eraseToAnyPublisher(),
                                           infectionsNumber: infectionsNumber.eraseToAnyPublisher(),
                                           infectionPeriod: infectionPeriod.eraseToAnyPublisher(),
                                           startSimulation: startSimulation.eraseToAnyPublisher())
        viewModel.setInput(input: input)
    }
    
    //MARK: - Slider Changed
    
    @objc
    private func sliderChanged(sender: UISlider) {
        switch sender {
        case peopleStackView.slider:
            let step: Float = 10
            let value = Int(round(sender.value / step) * step)
            peopleStackView.numberLabel.text = "\(value)"
            peopleNumber.send(value)
        case infectionsStackView.slider:
            let value = (Int(sender.value))
            infectionsStackView.numberLabel.text = "\(value)"
            infectionsNumber.send(value)
        case periodStackView.slider:
            let value = (Int(sender.value))
            periodStackView.numberLabel.text = "\(value)"
            infectionPeriod.send(value)
        default: break
        }
    }
    
    //MARK: - Start Button Pressed
    
    @objc
    private func startButtonPressed() {
        startSimulation.send(())
    }
}
