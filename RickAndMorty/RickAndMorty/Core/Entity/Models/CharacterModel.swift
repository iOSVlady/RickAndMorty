//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import UIKit

struct RickAndMortyCharacter: Equatable, Decodable, Hashable {
    let uuid = UUID()
    let id: Int
    let name: String
    let status: CharacterStatus
    let species: String
    let gender: String
    let imageUrl: String
    let created: Date
    let location: Location
    
    var statusColor: UIColor {
        switch status {
        case .alive:
            return .green
        case .dead:
            return .red
        case .unknown:
            return .gray
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case species = "species"
        case gender = "gender"
        case imageUrl = "image"
        case created = "created"
        case location = "location"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

struct Location: Equatable, Decodable {
    let name: String
    let url: String
}

// MARK: - CharacterStatus Enum
extension RickAndMortyCharacter {
    enum CharacterStatus: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
}
