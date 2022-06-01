//
//  APIRequest.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 16/05/2022.
//

import Foundation

protocol APIRequest {
    associatedtype Response
    
    var urlRequest: URLRequest {get}
    func decodeResponse(data: Data) throws -> Response
}

struct SendAPIRequest {
    enum APIRequestError: Error {
        case itemNotFound
    }
    static func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw APIRequestError.itemNotFound
              }
        
        let decodeResponse = try request.decodeResponse(data: data)
        return(decodeResponse)
    }
}
