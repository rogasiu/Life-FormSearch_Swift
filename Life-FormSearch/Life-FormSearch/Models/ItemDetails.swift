//
//  ItemDetails.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 16/05/2022.
//

import Foundation
import UIKit

struct Root: Codable {
    let details: ItemResponse
    
    enum CodingKeys: String, CodingKey {
        case details = "taxonConcept"
    }
}

struct ItemResponse: Codable {
    
    enum ItemResponseError: Error, LocalizedError {
        case detailsNotFound
    }
    
    let details: [ItemDetails]?
    let taxonConcepts: [ScientificClassification]?
    let scientificName: String
        
    enum CodingKeys: String, CodingKey {
        case details = "dataObjects"
        case taxonConcepts
        case scientificName
    }
}

struct ItemDetails: Codable {
    let imageUrl: URL?
    let mimeType: String?
    let rightsHolder: String?
    let agents: [Agent]
    let license: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "eolMediaURL"
        case mimeType
        case rightsHolder
        case agents
        case license
    }
}

struct Agent: Codable {
    let role: String
    let fullName: String
    
    enum CodingKeys: String, CodingKey {
        case role
        case fullName = "full_name"
    }
}

struct ScientificClassification: Codable {
    let nameAccordingTo: String
    let identifier: Int
    let scientificName: String
}

struct HierarchyItems: Codable {
    let ancestors: [Taxon]
}

struct Taxon: Codable {
    let taxonRank: String?
    let scientificName: String
}



