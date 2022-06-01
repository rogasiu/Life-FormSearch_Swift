//
//  ItemDetailsAPIRequest.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 16/05/2022.
//

import Foundation

struct LicenseAPIRequest: APIRequest {
    let identifier: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://eol.org/api/pages/1.0/\(identifier).json")!
        urlComponents.queryItems = [URLQueryItem(name: "taxonomy", value: "true"),
        URLQueryItem(name: "images_per_page", value: "1"),
        URLQueryItem(name: "language", value: "en")]
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeResponse(data: Data) throws -> ItemResponse {
        let itemResponse = try JSONDecoder().decode(Root.self, from: data)
        return itemResponse.details
    }
}

struct DetailsAPIRequest: APIRequest {
    let identifier: String
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: "https://eol.org/api/hierarchy_entries/1.0/\(identifier).json")!
        urlComponents.queryItems = [URLQueryItem(name: "language", value: "en")]
        return URLRequest(url: urlComponents.url!)
    }
    
    func decodeResponse(data: Data) throws -> [Taxon] {
        let itemResponse = try JSONDecoder().decode(HierarchyItems.self, from: data)
        return itemResponse.ancestors
    }
}


