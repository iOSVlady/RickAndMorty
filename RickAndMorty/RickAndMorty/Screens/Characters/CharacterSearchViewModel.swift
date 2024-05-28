//
//  CharacterSearchViewModel.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import Combine

enum LoadingState {
    case scroll
    case start
}

class CharacterSearchViewModel: ObservableObject {
    @Published var characters: [RickAndMortyCharacter] = []
    
    private var previousPage = 1
    public var currentPage = 1
    private var isLoading = false
    public var cancellables = Set<AnyCancellable>()
    
    private let networkService: NetworkServiceProtocol
    private weak var coordinator: MainCoordinator?
    
    var name: String = ""
    var status: String = ""
    var gender: String = ""
    var location: String = ""
    
    init(networkService: NetworkServiceProtocol, coordinator: MainCoordinator?) {
        self.coordinator = coordinator
        self.networkService = networkService
    }
    
    func loadMoreCharacters(loadingState: LoadingState) {
        guard !isLoading else { return }
        isLoading = true
        if loadingState == .scroll {
            currentPage += 1
        }
        
        let request = CharactersRequest(name: name, status: status, gender: gender, location: location, page: currentPage)
        
        networkService.fetch(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                if case .failure(let error) = completion {
                    print("Error loading characters: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if loadingState == .start {
                    self.characters = response.results
                } else if self.currentPage > self.previousPage {
                    self.characters.append(contentsOf: response.results)
                }
                
                self.previousPage = self.currentPage
                
            })
            .store(in: &cancellables)
    }
    
    func openInfoPage(character: RickAndMortyCharacter) {
        coordinator?.push(page: .characterInfo(character: character))
    }
    
    func applyFilter(name: String? = nil, status: String? = nil, gender: String? = nil) {
        let isResetting = (self.status == status && status != nil) ||
        (self.name == name && name != nil) ||
        (self.gender == gender && gender != nil)
        
        self.name = isResetting ? "" : (name ?? self.name)
        self.status = isResetting ? "" : (status ?? self.status)
        self.gender = isResetting ? "" : (gender ?? self.gender)
        
        self.characters.removeAll()
        self.currentPage = 1
        loadMoreCharacters(loadingState: .start)
    }
}
