//
//  ForgetPassowrd.swift
//  gallery-project
//
//  Created by Ankush Sharma on 24/04/23.
//

import Foundation


// MARK: - ForgetPassword
struct ForgetPassword: Codable {
    let statusCode: Int
    let message: String
    let data: jsonnull?
}

// MARK: - Encode/decode helpers

class jsonnull: Codable, Hashable {

    public static func == (lhs: jsonnull, rhs: jsonnull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for jsonnull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
