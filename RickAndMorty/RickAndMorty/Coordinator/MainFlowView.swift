//
//  MainFlowView.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import SwiftUI

struct MainFlowView: View {
    @ObservedObject private var coordinator: MainCoordinator
    
    init(targetPage: MainCoordinatorPage, onFinished: @escaping MainFlowOnFinishedHandler) {
        let coordinator = DIContainer.shared.mainCoordinator
        coordinator.set(targetPage: targetPage)
        coordinator.set(onFinished: onFinished)
        self.coordinator = coordinator
        Task { @MainActor in
            let rootPage = await coordinator.getInitialRootPage()
            coordinator.setRootView(to: rootPage)
        }
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationStack) {
            EmptyView()
                .transition(.asymmetric(insertion: .opacity, removal: .identity))
                .navigationDestination(for: MainCoordinatorPage.self) { page in
                    GeometryReader { _ in
                        coordinator.build(page: page)
                            .toolbar(.hidden, for: .navigationBar)
                            .toolbar(.hidden, for: .tabBar)
                            .toolbar(.hidden, for: .bottomBar)
                    }
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover: fullScreenCover)
                }
        }
    }
}
