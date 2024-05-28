//
//  CharacterView.swift
//  RickAndMorty
//
//  Created by Vlady on 28.05.2024.
//

import SwiftUI

struct CharacterView: View {
    let character: RickAndMortyCharacter
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: character.imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                } else {
                    ProgressView()
                        .frame(width: 70, height: 70)
                }
            }
            
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                    .foregroundColor(Color(cgColor: CGColor(red: 20/255, green: 0/255, blue: 52/255, alpha: 1)))
                Text(character.species)
                    .font(.subheadline)
                    .foregroundColor(Color(cgColor: CGColor(red: 20/255, green: 0/255, blue: 52/255, alpha: 0.6)))
                Spacer()
            }
            .padding(.leading, 5)
            
            Spacer()
        }
        .padding()
        .background(colorPicker)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(character.status == .unknown ? Color.gray.opacity(0.2) : .clear, lineWidth: 1.5)
        )
        .padding(.horizontal, 20)
        .frame(height: 100)
        
    }
    
    var colorPicker: Color {
        switch character.status {
        case .alive:
            return .blue.opacity(0.1)
        case .dead:
            return .red.opacity(0.1)
        case .unknown:
            return .clear
        }
    }
}

#Preview {
    CharacterView(character: RickAndMortyCharacter(id: 0, name: "Hello", status: .alive, species: "Nobody", gender: "Male", imageUrl: "https://i.stack.imgur.com/GsDIl.jpg", created: Date(), location: Location(name: "Some", url: "")))
}
