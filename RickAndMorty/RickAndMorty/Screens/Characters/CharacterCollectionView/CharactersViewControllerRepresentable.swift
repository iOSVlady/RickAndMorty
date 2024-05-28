//
//  CharactersViewControllerRepresentable.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//


import SwiftUI
import UIKit

struct CharactersViewControllerRepresentable: UIViewControllerRepresentable {
    
    var viewModel: CharacterSearchViewModel
    
    func makeUIViewController(context: Context) -> CharactersViewController {
        return CharactersViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: CharactersViewController, context: Context) {}
}
