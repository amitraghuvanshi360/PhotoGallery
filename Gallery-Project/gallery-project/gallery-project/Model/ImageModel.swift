//
//  ImageModel.swift
//  gallery-project
//
//  Created by Ankush Sharma on 26/04/23.
//

import Foundation


// MARK: - ImageModelElement
struct ImageModel: Codable {
    let statusCode: Int
    let message: String
    let data: [ImageCollection]?
}

// MARK: - ImageCollection
struct ImageCollection: Codable {
    let id: Int
    let userImage: String
}
