//
//  CountryModel.swift
//  gallery-project
//
//  Created by Ankush Sharma on 18/04/23.
//


// MARK: - CountryElement
import Foundation

struct CountryElement: Codable {
    let name, dialCode, code: String

    enum CodingKeys: String, CodingKey {
        case name
        case dialCode = "dial_code"
        case code
    }
}

typealias Country = [CountryElement]
