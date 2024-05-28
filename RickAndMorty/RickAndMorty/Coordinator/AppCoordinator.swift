//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import SwiftUI

enum MainCoordinatorPage: NavigationCoordinatorPage {
    var id: Int { self.hashValue }

    case undefined
    case charactersList
    case characterInfo(character: RickAndMortyCharacter)
    
    var orderNumber: Int {
        switch self {
        case .undefined: 0
        case .charactersList: 1
        case .characterInfo: 2
        }
    }
}

enum MainCoordinatorSheet: String, NavigationCoordinatorSheet {
    var id: String { self.rawValue }

    case none
    case notImplemented
}

enum MainCoordinatorFullScreenCover: String, NavigationCoordinatorFullScreenCover {
    var id: String { self.rawValue }

    case backActionAlert
    case noNetwork
}

protocol CacheableView: View {
    associatedtype ContentView: View
    @ViewBuilder func content() -> ContentView
}

struct GenericCacheableView<ContentView: View>: CacheableView {
    var contentProvider: () -> ContentView

    init(_ provider: @escaping () -> ContentView) {
        self.contentProvider = provider
    }

    func content() -> ContentView {
        contentProvider()
    }

    var body: some View {
        self.content()
    }
}

typealias MainFlowOnFinishedHandler = () -> Void

final class MainCoordinator: NavigationCoordinator {
    private var onFinished: MainFlowOnFinishedHandler?
    
    var viewCache: [MainCoordinatorPage: AnyView] = [:]

    @Published var navigationStack: [MainCoordinatorPage] = []
    @Published var sheet: MainCoordinatorSheet?
    @Published var fullScreenCover: MainCoordinatorFullScreenCover?

    
    private(set) var targetPage: MainCoordinatorPage = .undefined
    var rootPageIndex: Int?
    var currentPage: MainCoordinatorPage { navigationStack.last ?? .undefined }
    var email: String = ""
    var isActiveFlow: Bool { currentPage != .undefined }
    
    init() {}

    func reset() {
//        onFinished = nil
        rootPageIndex = nil
        dismissSheet()
        dismissFullScreenCover()
        targetPage = .undefined
        email = ""
        set(navigationStack: [])
        viewCache = [:]
    }

    func set(targetPage: MainCoordinatorPage) {
        self.targetPage = targetPage
    }

    func trySet(targetPage: MainCoordinatorPage) -> Bool {
        guard targetPage.orderNumber > currentPage.orderNumber else {
            return false
        }
        set(targetPage: targetPage)
        return true
    }

    func set(onFinished: @escaping MainFlowOnFinishedHandler) {
        self.onFinished = onFinished
    }

    func build(page: MainCoordinatorPage) -> some View {
        if let cachedView = viewCache[page] {
            return cachedView
        } else {
            let newView = AnyView(self.createView(for: page))
            viewCache[page] = newView
            return newView
        }
    }
    
    @ViewBuilder
     private func createView(for page: MainCoordinatorPage) -> some View {
         switch page {
         case .undefined:
             EmptyView()
         case .charactersList:
             CharacterSearchView(viewModel: CharacterSearchViewModel(networkService: NetworkService(), coordinator: self))
         case .characterInfo(let character):
             CharacterInfoView(viewModel: CharacterInfoViewModel(character: character, coordinator: self))
         }
     }

    @ViewBuilder
    func build(sheet: MainCoordinatorSheet) -> some View {
        switch sheet {
        case .none:
            EmptyView()
        case .notImplemented:
            VStack {
                Spacer()
                Spacer()
                Color.green.frame(height: 1)
                    .padding(.top, 16)
                Text("UNDER CONSTRACTION")
                    .foregroundStyle(Color.green)
                    .multilineTextAlignment(.center)
                Color.green.frame(height: 1)
                    .padding(.bottom, 16)
                Spacer()
                Button(action: { [weak self] in self?.dismissSheet() }, label: {
                    Text("dismiss")
                })
                Button(action: {
                    self.popToRoot()
                    self.dismissSheet()
                }, label: {
                    Text("pop to root")
                })
            }
            .padding(20)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }

    @ViewBuilder
    func build(fullScreenCover: MainCoordinatorFullScreenCover) -> some View {
        switch fullScreenCover {
        case .backActionAlert:
            EmptyView()
        case .noNetwork:
            VStack(spacing: 10) {
                Spacer()
                Image("network.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .padding(.vertical, 20)
                    .shadow(radius: 5)
                
                Text("No connection")
                Text("Failed to connect. Please check your network and try again!")
                Button(action: {
                    self.openNetworkSettings()
                }, label: {
                    Text("Settings")
                })
//                .buttonStyle(ChunkyButton(isSelected: false, height: 40))
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
    
    private func openNetworkSettings() {
        if let url = URL(string: "App-Prefs:root=WIFI") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @MainActor
    func getInitialRootPage() async -> MainCoordinatorPage {
        // Questions
        return targetPage
    }

    func setRootView(to page: MainCoordinatorPage, navigationStack: [MainCoordinatorPage] = []) {
        var temp: [MainCoordinatorPage] = [page]
        temp.append(contentsOf: navigationStack)
        rootPageIndex = self.navigationStack.endIndex
        set(navigationStack: temp)
    }

    func dismissFlow() {
        onFinished?()
        reset()
    }
}
