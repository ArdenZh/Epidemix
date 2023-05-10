//
//  InfectedNumberView.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 06.05.2023.
//

import UIKit

private enum Constants {
    static let title = "Number of infected"
}

final class InfectedNumberStackView: UIStackView {

    let title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = Constants.title
        title.textColor = .label
        title.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return title
    }()
    
    let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        progressView.progress = 0.5
        return progressView
    }()
    
    let numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.textColor = .secondaryLabel
        numberLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return numberLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .equalSpacing
        spacing = 4
        addArrangedSubview(title)
        addArrangedSubview(progressView)
        addArrangedSubview(numberLabel)
    }

}
