//
//  GeneralAPIResponse.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation

struct GeneralAPIResponse<T: Decodable>: Decodable {
    let pageInfo: PageInfo
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case pageInfo = "info"
        case results = "results"
    }
}
