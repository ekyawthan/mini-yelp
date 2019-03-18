//
//  PlaceDetailResult.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

struct PlaceDetailResult: Codable {
    let result: PlaceDetail
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case result, status
    }
}

struct PlaceDetail: Codable {
    let id, name: String
    let photos: [Photo]?
    let placeID: String
    let rating: Double
    let reviews: [Review]?
    let formattedAddress : String?
    let userRatingsTotal: Int
    var sentimentingRanking : Int64 = 0 // max = 5 
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case id, name, photos
        case placeID = "place_id"
        case rating, reviews
        case userRatingsTotal = "user_ratings_total"
    }
}

struct Photo: Codable {
    let height: Int
    let htmlAttributions: [String]
    let photoReference: String
    let width: Int
    
    enum CodingKeys: String, CodingKey {
        case height
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width
    }
}

struct Review: Codable {
    let authorName: String
    let authorURL: String
    let language: String?
    let profilePhotoURL: String
    let rating: Int
    let relativeTimeDescription, text: String
    let time: Int
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorURL = "author_url"
        case language
        case profilePhotoURL = "profile_photo_url"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text, time
    }
}
