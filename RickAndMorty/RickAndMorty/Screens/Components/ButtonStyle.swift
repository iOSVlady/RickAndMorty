//
//  ButtonStyle.swift
//  RickAndMorty
//
//  Created by Vlady on 28.05.2024.
//

import Foundation
import SwiftUI

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Circle().fill(Color.white))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
