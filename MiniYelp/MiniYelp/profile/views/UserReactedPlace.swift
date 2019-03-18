//
//  UserReactedPlace.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

struct UserReactedPlace : Codable {
    let status : String
    let result : [MiniYelpPlace]
}

struct MiniYelpPlace: Codable {
    let id: String
    let googleID: String
    let placeID: String
    let priceLevel: Int
    let rating: Double
    let reference: String
    let userRatingsTotal: Int
    let v: Int
    let reactions: [Reaction]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case googleID = "google_id"
        case placeID = "placeId"
        case priceLevel = "priceLevel"
        case rating = "rating"
        case reference = "reference"
        case userRatingsTotal = "userRatingsTotal"
        case v = "__v"
        case reactions = "reactions"
        case name = "name"
    }
}
