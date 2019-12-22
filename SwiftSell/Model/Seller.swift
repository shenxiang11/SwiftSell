// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let seller = try Seller(json)

import Foundation

// MARK: - Seller
struct Seller {
    let name, sellerDescription: String
    let deliveryTime: Int
    let score, serviceScore, foodScore, rankRate, minPrice, deliveryPrice: Double
    let ratingCount, sellCount: Int
    let bulletin: String
    let supports: [Support]
    let avatar: String
    let pics: [String]
    let infos: [String]
}

// MARK: - Support
struct Support {
    let type: supportIconType
    let supportDescription: String
}

enum supportIconType: Int {
    case decrease = 0
    case discount = 1
    case special = 2
    case invoice = 3
    case guarantee = 4
}
