//
//  SetNewPassword.swift
//  gallery-project
//
//  Created by Ankush Sharma on 25/04/23.
//

import Foundation

// MARK: - SetNewPassword
struct SetNewPassword: Codable {
    let statusCode: Int
    let message: String
    let data: JSONNullify?
}

// MARK: - Encode/decode helpers

class JSONNullify: Codable, Hashable {

    public static func == (lhs: JSONNullify, rhs: JSONNullify) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNullify.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
