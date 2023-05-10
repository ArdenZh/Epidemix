//
//  ViewController.swift
//  Epidemix
//
//  Created by Arden Zhakhin on 05.05.2023.
//

import UIKit
import Combine

private enum Constants {
    static let title = "Epidemix"
    static let zoomImage = "magnifyingglass"
    static let zoomInImage = "plus.magnifyingglass"
    static let zoomOutImage = "minus.magnifyingglass"
    static let cellIdentifier = "personCell"
}

final class SimulationViewController: UIViewController {

    //MARK: - Properties
    
    private let viewModel: SimulationViewModelProtocol
    private lazy var progressStackView = InfectedNumberStackView()
    private lazy var collectionView = UICollectionView()
    private lazy var dataSource = setupDataSource()
    private var cancellables = Set<AnyCancellable>()
    private var cellsPerRow = 3
    
    //MARK: - Init / Deinit
    
    init(viewModel: SimulationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(to: viewModel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - Setuo UI
    
    private func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        setupNavigationBar()
        setupProgressStackView()
        setupCollectionView()
        addViews()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Constants.title
        let menuActions = [
            UIAction(title: "Zoom in",
                     image: UIImage(systemName: Constants.zoomInImage),
                     handler: {[weak self] _ in self?.zoomIn()}),
            UIAction(title: "Zoom out",
                     image: UIImage(systemName: Constants.zoomOutImage),
                     handler: {[weak self] _ in self?.zoomOut()})]
        let menu = UIMenu(title: "", options: .displayInline, children: menuActions)
        let zoomBarButton = UIBarButtonItem(image: UIImage(systemName: Constants.zoomImage), menu: menu)
        navigationItem.rightBarButtonItem = zoomBarButton
    }

    private func setupProgressStackView() {
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let cellSize = (view.bounds.width - 32 - 8) / 3
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layer.cornerRadius = 10
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(SimulationCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
    }
    
    private func addViews(){
        view.addSubview(progressStackView)
        view.addSubview(collectionView)
        constraintViews()
    }
    
    private func constraintViews() {
        NSLayoutConstraint.activate([
            progressStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            progressStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Binding
    
    private func bind(to viewModel: SimulationViewModelProtocol) {
        cancellables = [updateCollectionSubscription(),
                        updateSliderSubscription(),
                        updateSliderDescriptionSubscription(),
                        updateNumberOfColumnsSubscription()]
    }
    
    private func updateCollectionSubscription() -> AnyCancellable {
        viewModel.personModels
            .receive(on: DispatchQueue.main)
            .sink {[weak self] persons in
                guard let self = self else {return}
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([0])
                snapshot.appendItems(persons)
                self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func updateSliderSubscription() -> AnyCancellable {
        viewModel.infectedProgress
            .receive(on: DispatchQueue.main)
            .sink {[weak self] infectedProgress in
                self?.progressStackView.progressView.progress = infectedProgress
        }
    }
    
    private func updateSliderDescriptionSubscription() -> AnyCancellable {
        viewModel.infectedProgressString
            .receive(on: DispatchQueue.main)
            .sink {[weak self] infectedProgressString in
                self?.progressStackView.numberLabel.text = infectedProgressString
        }
    }

    private func updateNumberOfColumnsSubscription() -> AnyCancellable {
        viewModel.numberOfColumns
            .receive(on: DispatchQueue.main)
            .sink { [weak self] numberOfColumns in
                guard let self = self else {return}
                self.cellsPerRow = numberOfColumns
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()
            }
    }

    //MARK: - Zoom
    
    private func zoomIn() {
        viewModel.zoom(increase: true)
    }
    
    private func zoomOut() {
        viewModel.zoom(increase: false)
    }
    
    //MARK: - Data Source
    
    private func setupDataSource() -> UICollectionViewDiffableDataSource<Int, PersonModel> {
        let dataSource = UICollectionViewDiffableDataSource<Int, PersonModel>(collectionView: collectionView) { (collectionView, indexPath, person) -> UICollectionViewCell? in
            
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? SimulationCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(with: person)
            return cell
        }
        return dataSource
    }
}

    //MARK: - UICollectionViewDelegate

extension SimulationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        let item = snapshot.itemIdentifiers[indexPath.row]
        if item.personType == .healthy {
            viewModel.personDidSelect(at: indexPath.row)
        }
    }
    
    // Мультивыбор элементов с помощью свайпа
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }
}

    //MARK: - UICollectionViewDelegateFlowLayout

extension SimulationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 10 * (cellsPerRow - 1)
        let availableWidth = collectionView.bounds.width - CGFloat(padding)
        let cellWidth = availableWidth / CGFloat(cellsPerRow)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
