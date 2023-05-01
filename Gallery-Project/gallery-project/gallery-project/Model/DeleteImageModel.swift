//
//  DeleteImageModel.swift
//  gallery-project
//
//  Created by Ankush Sharma on 26/04/23.
//

import Foundation



// MARK: - DeleteImage
struct DeleteImage: Codable {
    let statusCode: Int
    let message: String
    let data: JSONNil?
}

// MARK: - Encode/decode helpers

class JSONNil: Codable, Hashable {

    public static func == (lhs: JSONNil, rhs: JSONNil) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNil.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNil"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
