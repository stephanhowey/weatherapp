//
//  MockURLRequester.swift
//  WeatherTests
//
//  Created by Stephan Howey on 11.06.23.
//

import Foundation
@testable import Weather

class MockURLRequester {
    
    enum RequestingError: Error {
        case resourceUnavailable
    }
    
    let fileName: String
    let fileType: String
    
    required init(file name: String, of type: String = "json") {
        fileName = name
        fileType = type
    }
}

extension MockURLRequester: URLRequesting {
    
    func result<T: Decodable>(from request: URLRequest) async throws -> T {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileType) else {
            throw RequestingError.resourceUnavailable
        }
 
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoder = JSONDecoder()
        let decodable = try decoder.decode(T.self, from: data)
        return decodable
    }
}
