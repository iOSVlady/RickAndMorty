//
//  APIError.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation

struct APIError: Decodable, Error {
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error"
    }
}
