//
//  MiniYelpPlaceDetail.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation


struct MiniYelpPlaceDetail: Codable {
    let id, googleID, placeID: String
    let priceLevel, rating: Int
    let reference: String
    let userRatingsTotal, v: Int
    let reactions: [Reaction]
    let types: [String]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case googleID = "google_id"
        case placeID = "placeId"
        case priceLevel, rating, reference, userRatingsTotal
        case v = "__v"
        case reactions, types, name
    }
}

struct Reaction: Codable {
    let id: String
    let v: Int
    let restaurantID: String
    let userid: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case restaurantID, userid, type
    }
}
