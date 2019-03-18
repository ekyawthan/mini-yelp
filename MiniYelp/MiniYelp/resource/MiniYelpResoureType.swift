
//
//  MiniYelpApi.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

typealias  RequestBody = [String : String]
typealias RequestQuery = [String : String]

struct Login : Encodable {
    let username : String
}

enum MiniYelpResoureType {
    case googlePlace(query : RequestQuery)
    case googlePlaceDetail(query : RequestQuery)
    case login
    case user(withUserid : String)
    case miniPlace(byPlaceId : String)
    case updateViewCount(body : RequestBody)
    case updateReaction(body : RequestBody)
    case byBatch(ids : RequestQuery)
    
}

extension MiniYelpResoureType  : TinyResourceProtocol {
    var baseurl : String {
        return "https://obscure-shelf-96048.herokuapp.com/api"
    }

    
    var urlRequest: URLRequest {
        var request : URLRequest?
        switch self {
        case .googlePlace(let query):
            guard var component = URLComponents(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json") else {
                break
            }
            component.setQueryItems(from: query)
            request = URLRequest(url: component.url!)
            request?.httpMethod  = "POST"
        case .googlePlaceDetail(let query):
            guard var component = URLComponents(string: "https://maps.googleapis.com/maps/api/place/details/json") else {
                break
            }
            var param : [String : String] = [
                "key" : "AIzaSyAzhyq0ppjSpZwxDC2IZKwUfxHFLo0hfmE",
                "fields" : "rating,review,id,name,place_id,photos,price_level,user_ratings_total,formatted_address"
            ]
            query.forEach{
                param[$0.key] = $0.value
                
            }
            component.setQueryItems(from: param)
            request = URLRequest(url: component.url!)
            request?.httpMethod = "POST"
        case .miniPlace(let byPlaceId):
            guard var urlComponent  = URLComponents(string: baseurl + "/restaurant/get") else { break }
            urlComponent.setQueryItems(from: ["placeId" : byPlaceId])
            request = URLRequest(url: urlComponent.url!)
        case .login:
            guard let url = URL(string: "https://obscure-shelf-96048.herokuapp.com/api/auth/login") else {
                fatalError("invalidate url")
            }
            let postData = NSMutableData(data: "username=user".data(using: String.Encoding.utf8)!)
            request = URLRequest(url: url)
            request?.httpMethod = "POST"
            request?.httpBody = postData as Data
        case .updateViewCount(let body):
            request = URLRequest(url: URL(string: baseurl +  "/restaurant/view")!)
            request?.encodeParameters(parameters: body)
            request?.httpMethod = "POST"
        case .user(let userid):
            guard var urlComponent  = URLComponents(string: baseurl + "/auth/user") else { break }
            urlComponent.setQueryItems(from: ["userid" : userid])
            request = URLRequest(url: urlComponent.url!)
            request?.httpMethod = "GET"
        case .updateReaction(let body):
            request  = URLRequest(url: URL(string: baseurl + "/restaurant/update")!)
            request?.httpMethod = "POST"
            request?.encodeParameters(parameters: body)
            
        case .byBatch(let ids):
            guard var components = URLComponents(string: baseurl + "/restaurant/bybatch") else {
                fatalError("invalidate url")
            }
        
            components.setQueryItems(from: ids)
            request = URLRequest(url: components.url!)
            request?.httpMethod = "GET"
        }
        

        
        return request!
    }
    
}

