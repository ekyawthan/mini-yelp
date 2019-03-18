//
//  URLComponents.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation


extension URLComponents {
    mutating func setQueryItems(from : [String : String]) {
        self.queryItems = from.map{URLQueryItem(name: $0.key, value: $0.value)}
    }
}
