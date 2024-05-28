//
//  PageInfo.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation

struct PageInfo: Decodable {
    let itemCount: Int
    let pageCount: Int
    let nextPageURL: String?
    let previousPageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case itemCount = "count"
        case pageCount = "pages"
        case nextPageURL = "next"
        case previousPageURL = "prev"
    }
}
