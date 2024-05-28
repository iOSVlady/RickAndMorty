//
//  CharacterInfoViewModel.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation

class CharacterInfoViewModel: ObservableObject {
    let character: RickAndMortyCharacter
    weak var coordinator: MainCoordinator?
    
    init(character: RickAndMortyCharacter, coordinator: MainCoordinator?) {
        self.character = character
        self.coordinator = coordinator
    }
    
    func goBack() {
        coordinator?.pop()
    }
}
