//
//  URLRequesting.swift
//  Weather
//
//  Created by Stephan Howey on 10.06.23.
//

import Foundation

protocol URLRequesting {
    func result<T: Decodable>(from request: URLRequest) async throws -> T
}

extension URLRequesting {
    
    func result<T: Decodable>(from request: URLRequest) async throws -> T {
        
        let responseTuple = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: responseTuple.0)
    }
}
