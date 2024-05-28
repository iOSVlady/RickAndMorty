//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Vlady on 27.05.2024.
//

import Foundation
import Combine

class NetworkService: NetworkServiceProtocol {
    
    let customDecoder = JSONDecoder()
    
    init() {
        setCustomDecoder()
    }
    
    private func setCustomDecoder() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        customDecoder.dateDecodingStrategy = .formatted(formatter)
    }
    
    func fetch<T: NetworkRequestProtocol>(_ request: T) -> AnyPublisher<T.ResponseType, Error> {
        var urlRequest = URLRequest(url: request.endpoint.url)
        urlRequest.httpMethod = request.method.rawValue
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> T.ResponseType in
                guard let urlResponse = response as? HTTPURLResponse,
                      (200...299).contains(urlResponse.statusCode) else {
                          let decodedErrorResponse = try self.customDecoder.decode(APIError.self, from: data)
                          throw decodedErrorResponse
                      }
                return try self.customDecoder.decode(T.ResponseType.self, from: data)
            }
            .eraseToAnyPublisher()
    }
}
