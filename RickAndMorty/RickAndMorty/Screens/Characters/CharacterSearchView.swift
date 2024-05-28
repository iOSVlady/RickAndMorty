//
//  CharacterSearchView.swift
//  RickAndMorty
//
//  Created by Vlady on 28.05.2024.
//

import Foundation
import SwiftUI

struct CharacterSearchView: View {
    @ObservedObject var viewModel: CharacterSearchViewModel
    
    private let filters: [RickAndMortyCharacter.CharacterStatus] = [.alive, .dead, .unknown]
    
    var body: some View {
        VStack {
            HStack {
                Text("Characters")
                    .font(.title.bold())
                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filters, id: \.self) { status in
                        Button(action: {
                            viewModel.applyFilter(status: status.rawValue)
                        }) {
                            Text(status.rawValue.capitalized)
                                .foregroundColor(viewModel.status == status.rawValue ? .white : .black)
                                .padding(10)
                                .background(viewModel.status == status.rawValue ? colorPicker(status: status) : Color.clear)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
            }
            
            CharactersViewControllerRepresentable(viewModel: viewModel)
                .ignoresSafeArea(edges: .bottom)
        }
    }
    
    func colorPicker(status: RickAndMortyCharacter.CharacterStatus) -> Color {
        switch status {
        case .alive:
            return .blue.opacity(0.8)
        case .dead:
            return .red.opacity(0.8)
        case .unknown:
            return .gray.opacity(0.2)
        }
    }
}

#Preview {
    CharacterSearchView(viewModel: CharacterSearchViewModel(networkService: NetworkService(), coordinator: MainCoordinator()))
}
