//
//  ImageAPIRequest.swift
//  Life-FormSearch
//
//  Created by Rogasiu on 17/05/2022.
//

import Foundation
import UIKit
struct ImageAPIRequest: APIRequest {
    enum ResponseError: Error {
        case invalidImageData
    }
    let url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func decodeResponse(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw ResponseError.invalidImageData
        }
        return image
    }
}
