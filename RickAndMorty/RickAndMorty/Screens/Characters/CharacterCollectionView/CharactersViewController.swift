//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import UIKit
import SwiftUI
import Combine

class CharactersViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: CharacterSearchViewModel
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, RickAndMortyCharacter>!
    private var cancellables = Set<AnyCancellable>()
    private let itemHeight: CGFloat = 100
    private var previousCharacterCount = 0
    
    init(viewModel: CharacterSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupBindings()
        viewModel.loadMoreCharacters(loadingState: .start)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: itemHeight)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPrefetchingEnabled = true
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "characterCell")
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        dataSource = UICollectionViewDiffableDataSource<Int, RickAndMortyCharacter>(collectionView: collectionView) { (collectionView, indexPath, character) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as! CharacterCell
            cell.configure(with: character)
            return cell
        }
    }
    
    private func setupBindings() {
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newCharacters in
                self?.updateCollectionView(with: newCharacters)
            }
            .store(in: &cancellables)
    }
    
    private func updateCollectionView(with newCharacters: [RickAndMortyCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, RickAndMortyCharacter>()
        snapshot.appendSections([0])
        snapshot.appendItems(newCharacters)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height

        if offsetY > contentHeight - frameHeight {
            viewModel.loadMoreCharacters(loadingState: .scroll)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        viewModel.openInfoPage(character: character)
    }
}
