//
//  CollectionCell.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 05.05.2023.
//

import UIKit

protocol ConfigurableViewProtocol {
    associatedtype ConfigurationModel
    func configure(with model: ConfigurationModel)
}

final class SimulationCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private lazy var id = UUID()
    private lazy var personType: PersonType = .infected
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "figure.stand")?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.addSubview(imageView)
        contentView.backgroundColor = .systemGray5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.bounds.size
        imageView.frame = CGRect(x: (size.width - size.width * 2 / 3) / 2,
                                 y: (size.height - size.height * 2 / 3) / 2,
                                 width: size.width * 2 / 3,
                                 height: size.height * 2 / 3)
    }
}

    //MARK: - Cell configuring

extension SimulationCollectionViewCell: ConfigurableViewProtocol {
    typealias ConfigurationModel = PersonModel
    
    func configure(with model: PersonModel) {
        id = model.id
        switch model.personType {
        case .healthy:
            imageView.tintColor = .systemBackground
        case .infected:
            imageView.tintColor = UIColor(named: "red")
        }
        personType = model.personType
    }
}
