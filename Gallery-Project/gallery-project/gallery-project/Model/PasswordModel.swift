//
//  PasswordModel.swift
//  gallery-project
//
//  Created by Ankush Sharma on 09/05/23.
//

import Foundation


// MARK: - ChangePassword
struct PasswordModel: Codable {
    let statusCode: Int
    let message: String
    let data: JSON?
}

// MARK: - Encode/decode helpers

class JSON: Codable, Hashable {

    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSON.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

