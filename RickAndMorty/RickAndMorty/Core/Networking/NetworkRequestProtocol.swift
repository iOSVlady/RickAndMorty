//
//  NetworkRequestProtocol.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation

protocol NetworkRequestProtocol {
    associatedtype ResponseType: Decodable
    
    var endpoint: Endpoint { get }
    var method: HTTPMethod { get }
}
