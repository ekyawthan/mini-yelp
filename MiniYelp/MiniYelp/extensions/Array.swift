//
//  Array.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

extension Array where Element : Hashable {
    func mostFrequent() -> Array.Element? {
        var counts =    [Array.Element : Int]()
        self.forEach { counts[$0] = (counts[$0] ?? 0) + 1 }
        if let (value, _) = counts.max(by: {$0.1 < $1.1}) {
            return value
        }
        return nil
    }
}
