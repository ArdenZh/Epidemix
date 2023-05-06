//
//  SettingStackView.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import UIKit

final class SettingStackView: UIStackView {

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Title"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        titleLabel.setContentHuggingPriority(UILayoutPriority(749), for: .horizontal)
        return titleLabel
    }()
    
    let numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.text = "0"
        numberLabel.textColor = .label
        numberLabel.textAlignment = .right
        numberLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return numberLabel
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Description"
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return descriptionLabel
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = 0
//        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        slider.thumbTintColor = UIColor(named: "accentColor")
        return slider
    }()
    
    private lazy var peopleTitleStackView: UIStackView = {
        let peopleTitleStackView = UIStackView(arrangedSubviews: [titleLabel, numberLabel])
        peopleTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        peopleTitleStackView.axis = .horizontal
        peopleTitleStackView.distribution = .fill
        return peopleTitleStackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        axis = .vertical
        distribution = .equalSpacing
        spacing = 10
        translatesAutoresizingMaskIntoConstraints = false
        
        addArrangedSubview(peopleTitleStackView)
        addArrangedSubview(slider)
        addArrangedSubview(descriptionLabel)
    }
    
//    @objc
//    private func sliderChanged(sender: UISlider) {
//        if sender == slider {
//            numberLabel.text = "\(Int(sender.value))"
//        }
//    }
}
