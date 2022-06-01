//
//  SearchItemAPIRequest.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 16/05/2022.
//

import Foundation

struct SearchItemAPIRequest: APIRequest {
    
    var searchName: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://eol.org/api/search/1.0.json")!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: searchName),
        URLQueryItem(name: "page", value: "1")]
        
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeResponse(data: Data) throws -> [SearchItem] {
        let searchItem = try JSONDecoder().decode(SearchResponse.self, from: data)
        return searchItem.results
    }
    
    
    
}
