//
//  ConfirmPassword.swift
//  gallery-project
//
//  Created by Ankush Sharma on 25/04/23.
//

import Foundation


// MARK: - ConfirmPassword
struct ConfirmPassword: Codable {
    let statusCode: Int
    let message: String
    let data: JSONNulls?
}

// MARK: - Encode/decode helpers

class JSONNulls: Codable, Hashable {

    public static func == (lhs: JSONNulls, rhs: JSONNulls) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNulls.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
