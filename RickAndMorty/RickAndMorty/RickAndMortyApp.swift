//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            MainFlowView(targetPage: .charactersList, onFinished: {})
                .environment(\.colorScheme, .light)
        }
    }
}
