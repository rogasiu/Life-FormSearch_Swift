//
//  SearchItem.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 16/05/2022.
//

import Foundation

struct SearchResponse: Codable {
    let results: [SearchItem]
}

struct SearchItem: Codable {
    let id: Int
    let scientificName: String
    let commonName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case scientificName = "title"
        case commonName = "content"
    }
    
}
