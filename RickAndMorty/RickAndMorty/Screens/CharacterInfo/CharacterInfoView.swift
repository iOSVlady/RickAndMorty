//
//  CharacterInfoView.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import SwiftUI

struct CharacterInfoView: View {
    @ObservedObject var viewModel: CharacterInfoViewModel
    
    var body: some View {
        ZStack {
            // Main vertical stack for layout
            VStack(alignment: .leading, spacing: 0) {
                // Responsive image block
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: viewModel.character.imageUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                        case .failure(_):
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                        default:
                            ProgressView()
                                .frame(width: geometry.size.width, height: geometry.size.width)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.width)
                .padding(.bottom, 25)
                
                // Group for character information
                Group {
                    // Character name and status
                    HStack {
                        Text(viewModel.character.name)
                            .font(.largeTitle)
                        Spacer()
                        Text(viewModel.character.status.rawValue.capitalized)
                            .font(.subheadline)
                            .padding(10)
                            .background(colorPicker)
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 5)
                    
                    // Species and gender information
                    HStack {
                        Text(viewModel.character.species)
                            .font(.headline)
                        Circle()
                            .frame(width: 5, height: 5)
                            .padding(.top, 4)
                        Text(viewModel.character.gender)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    // Location information
                    HStack {
                        Text("Location:")
                            .font(.headline)
                        Text(viewModel.character.location.name)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            
            // Back navigation
            VStack {
                navigationBack(action: viewModel.backAction)
                    .padding(.leading, 20)
                    .padding(.top, 40)
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // Color picker based on character status
    var colorPicker: Color {
        switch viewModel.character.status {
        case .alive:
            return .green.opacity(0.8)
        case .dead:
            return .red.opacity(0.8)
        case .unknown:
            return .gray.opacity(0.2)
        }
    }
    
    // Navigation back button view
    public func navigationBack(action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button(action: action) {
                        Image(systemName: "arrow.backward")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 15)
                            .foregroundColor(.black)
                    }
                    .buttonStyle(CircleButtonStyle())
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    CharacterInfoView(viewModel: CharacterInfoViewModel(character: RickAndMortyCharacter(id: 0, name: "Hello", status: .alive, species: "Tiger", gender: "Male", imageUrl: "https://i.stack.imgur.com/GsDIl.jpg", created: Date(), location: Location(name: "", url: "")), coordinator: MainCoordinator()))
}
