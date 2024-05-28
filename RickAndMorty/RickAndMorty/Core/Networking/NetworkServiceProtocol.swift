//
//  NetworkServiceProtocol.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import Combine

protocol NetworkServiceProtocol: AnyObject {
    var customDecoder: JSONDecoder { get }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) -> AnyPublisher<T.ResponseType, Error>
}
