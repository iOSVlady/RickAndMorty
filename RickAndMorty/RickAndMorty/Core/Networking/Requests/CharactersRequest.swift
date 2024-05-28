//
//  CharactersRequest.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation

final class CharactersRequest: NetworkRequestProtocol {
    typealias ResponseType = GeneralAPIResponse<RickAndMortyCharacter>

    let endpoint: Endpoint
    let method: HTTPMethod = .GET

    init(name: String, status: String, gender: String, location: String, page: Int) {
        endpoint = .getCharacters(name: name, status: status,
                                  gender: gender, location: location, page: page)
    }
}
