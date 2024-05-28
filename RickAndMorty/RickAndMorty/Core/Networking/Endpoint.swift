//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

// MARK: - Base URL
extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        return url
    }
}

// MARK: - Endpoints
extension Endpoint {
    static func getCharacters(name: String, status: String, gender: String, location: String, page: Int) -> Self {
        Endpoint(
            path: "api/character/",
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "status", value: status),
                URLQueryItem(name: "gender", value: gender),
                URLQueryItem(name: "location", value: location)
            ]
        )
    }
}
