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
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: viewModel.character.imageUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                        } else if phase.error != nil {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.width)
                                .clipShape(RoundedRectangle(cornerRadius: 35))
                        } else {
                            ProgressView()
                                .frame(width: geometry.size.width, height: geometry.size.width)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.width)
                .padding(.bottom, 25)

                Group {
                    HStack {
                        Text(viewModel.character.name)
                            .font(.largeTitle)
                        Spacer()
                        Text("\(viewModel.character.status)".capitalized)
                            .font(.subheadline)
                            .padding(10)
                            .background(colorPicker)
                            .clipShape(.capsule)
                        
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Text("\(viewModel.character.species)")
                            .font(.headline)
                        Circle()
                            .frame(height: 5)
                            .padding(.top, 4)
                        Text("\(viewModel.character.gender)")
                            .font(.headline)
                            .foregroundStyle(.gray.opacity(0.9))
                        Spacer()
                    }.padding(.bottom, 10)
                    
                    HStack(spacing:0) {
                        Text("Location : ")
                            .font(.headline)
                        Text("\(viewModel.character.location.name)")
                    }
                    
                }.padding(.horizontal, 30)
                
                Spacer()
                
                
            }
            
            VStack {
                navigationBack(action: viewModel.goBack)
                    .padding(.leading, 20)
                    .padding(.top, 40)
                Spacer()
            }

        }.edgesIgnoringSafeArea(.top)
    }
    
    var colorPicker: Color {
        switch viewModel.character.status {
        case .alive:
            return .blue.opacity(0.8)
        case .dead:
            return .red.opacity(0.8)
        case .unknown:
            return .gray.opacity(0.2)
        }
    }
    
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
    
    struct CircleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(Circle().fill(Color.white))
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
        }
    }


    public func tabNavigationBar(label: String, colorScheme: ColorScheme) -> some View {
        HStack {
            Spacer()
            Text(label)
                .padding(.bottom, 10)
            Spacer()
        }
    }
}
#Preview {
    CharacterInfoView(viewModel: CharacterInfoViewModel(character: RickAndMortyCharacter(id: 0, name: "Hello", status: .alive, species: "Tiger", gender: "Male", imageUrl: "https://i.stack.imgur.com/GsDIl.jpg", created: Date(), location: Location(name: "", url: "")), coordinator: MainCoordinator()))
//
}
