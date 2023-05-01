//
//  UserModel.swift
//  gallery-project
//
//  Created by Ankush Sharma on 12/04/23.
//

import Foundation


struct User: Codable {
    let statusCode: Int
    let message: String
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let token, refreshToken: String
    let expiration: String
    let name, email: String
    let username: String?
}
