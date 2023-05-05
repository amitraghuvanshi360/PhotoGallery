//
//  GetUserDetails.swift
//  gallery-project
//
//  Created by Ankush Sharma on 03/05/23.
//

import Foundation


import Foundation

// MARK: - GetUserDetails
struct GetUserDetail: Codable {
    let statusCode: Int
    let message: String
    let data: UserData
}

struct UserData: Codable {
    let id: Int
    let name: String
    let email: String
    let phoneNumber: String
    let gender: String
    let country: String
    let hobby: Int
    let profileImage: String
}
