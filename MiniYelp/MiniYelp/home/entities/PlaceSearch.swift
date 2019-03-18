
//
//  PlaceSearch.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

struct PlaceSearch: Codable {
    let nextPageToken: String
    let results: [Place]?
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case nextPageToken = "next_page_token"
        case results, status
    }
}

struct Place: Codable {
    let icon: String
    let id, name: String
    let placeID: String
    let priceLevel: Int?
    let rating: Double
    let reference: String
    let types: [String]
    let userRatingsTotal: Int
    
    enum CodingKeys: String, CodingKey {
        case icon, id, name
        case placeID = "place_id"
        case priceLevel = "price_level"
        case rating, reference, types
        case userRatingsTotal = "user_ratings_total"
    }
}


extension Place : Equatable, CustomStringConvertible {
    var description: String {
        return self.name + " with " + self.placeID
    }
}
