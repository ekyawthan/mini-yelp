//
//  User.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/16/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation


struct User: Codable {
    let token, createdAt: String?
    let id, username: String
    let v: Int
    let reactions : [Reaction]
    
    enum CodingKeys: String, CodingKey {
        case token, createdAt, reactions
        case id = "_id"
        case username
        case v = "__v"
    }
}
