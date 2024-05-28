//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import SwiftUI
import UIKit

class CharacterCell: UICollectionViewCell {
    
    private var hostingController: UIHostingController<CharacterView>?
    private var character: RickAndMortyCharacter?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let characterView = CharacterView(character: RickAndMortyCharacter(id: 0, name: "", status: .alive, species: "", gender: "", imageUrl: "", created: Date(), location: Location(name: "", url: "")))
        let hostingController = UIHostingController(rootView: characterView)
        self.hostingController = hostingController
        
        guard let hostingView = hostingController.view else { return }
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostingView)
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with character: RickAndMortyCharacter) {
        self.character = character
        hostingController?.rootView = CharacterView(character: character)
    }
}
