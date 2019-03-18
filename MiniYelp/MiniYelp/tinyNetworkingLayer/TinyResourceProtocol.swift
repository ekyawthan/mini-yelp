//
//  TinyResourceProtocol.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

protocol TinyResourceProtocol {
    var urlRequest : URLRequest { get }
}
extension TinyResourceProtocol {
    func parse<A : Codable>(_ data : Data) throws -> A {
//        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
//        print(json)
        do {
            return try JSONDecoder().decode(A.self, from: data)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }
    }

}

