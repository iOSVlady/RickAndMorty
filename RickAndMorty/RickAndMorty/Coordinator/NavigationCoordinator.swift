//
//  NavigationCoordinator.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import SwiftUI

protocol NavigationCoordinatorPage: Identifiable, Hashable {
}

protocol NavigationCoordinatorSheet: Identifiable {
}

protocol NavigationCoordinatorFullScreenCover: Identifiable {
}

protocol NavigationCoordinator: ObservableObject {
    associatedtype Page: NavigationCoordinatorPage
    associatedtype Sheet: NavigationCoordinatorSheet
    associatedtype FullScreenCover: NavigationCoordinatorFullScreenCover

    var navigationStack: [Page] { get set }
    var sheet: Sheet? { get set }
    var fullScreenCover: FullScreenCover? { get set }
    var rootPageIndex: Int? { get set }
    var currentPage: Page { get }

    func push(page: Page)
    func push(pages: [Page])
    func pop()
    func popToRoot()
    func set(navigationStack: [Page])
    func present(sheet: Sheet)
    func present(fullScreenCover: FullScreenCover)
    func dismissSheet()
    func dismissFullScreenCover()
    func dismissFlow()

    associatedtype PageView: View
    func build(page: Page) -> PageView

    associatedtype SheetView: View
    func build(sheet: Sheet) -> SheetView

    associatedtype FullScreenCoverView: View
    func build(fullScreenCover: FullScreenCover) -> FullScreenCoverView
}

extension NavigationCoordinator {
    func push(page: Page) {
        Task {
            await MainActor.run {
                navigationStack.append(page)
            }
        }
    }
    
    func push(pages: [Page]) {
        Task {
            await MainActor.run {
                pages.forEach { navigationStack.append($0) }
            }
        }
    }
    
    func pop() {
        guard let rootPageIndex, rootPageIndex < navigationStack.count - 1  else {
            dismissFlow()
            return
        }
        navigationStack.removeLast()
    }
    
    func popToRoot() {
        guard let rootPageIndex, rootPageIndex < navigationStack.count - 1 else {
            return
        }
        navigationStack.removeLast(navigationStack.count - rootPageIndex - 1)
    }
    
    func set(navigationStack pages: [Page]) {
        Task {
            try await Task.sleep(nanoseconds: 100000000)
            guard !pages.isEmpty else {
                await MainActor.run {
                    navigationStack = []
                }
                return
            }
            await MainActor.run {
                pages.forEach { navigationStack.append($0) }
            }
        }
    }
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func dismissSheet() {
        Task {
            await MainActor.run {
                sheet = nil
            }
        }
    }
    
    func dismissFullScreenCover() {
        Task {
            await MainActor.run {
                fullScreenCover = nil
            }
        }
    }
}
