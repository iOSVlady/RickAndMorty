//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Vlady on 27.05.2024.
//

import XCTest
import Combine
import SwiftUI

class CharacterSearchViewModelTests: XCTestCase {
    var viewModel: CharacterSearchViewModel!
    var mockNetworkService: NetworkService!
    var cancellables: Set<AnyCancellable>!
    var mockCoordinator: MainCoordinator!

    override func setUp() {
        super.setUp()
        mockNetworkService = NetworkService()
        mockCoordinator = MainCoordinator()
        viewModel = CharacterSearchViewModel(networkService: mockNetworkService, coordinator: mockCoordinator)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockCoordinator = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadMoreCharactersInitially() {
        // Given
        let expectation = XCTestExpectation(description: "Characters load initially")
        
        // When
        viewModel.$characters
            .sink { characters in
                if !characters.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadMoreCharacters(loadingState: .start)

        // Then
        wait(for: [expectation], timeout: 15.0)
        XCTAssertFalse(viewModel.characters.isEmpty, "Characters should not be empty after initial load")
    }
    
    func testLoadMoreCharactersOnScroll() {
        // Given
        let initialCount = viewModel.characters.count
        let expectation = XCTestExpectation(description: "Load more characters on scroll")
        
        // When
        viewModel.$characters
            .dropFirst() // Skip initial load
            .sink { characters in
                if characters.count > initialCount {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadMoreCharacters(loadingState: .scroll)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
        XCTAssertTrue(viewModel.characters.count > initialCount, "Characters count should increase on scrolling")
    }
}



