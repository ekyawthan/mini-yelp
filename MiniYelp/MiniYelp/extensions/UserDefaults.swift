//
//  UserDefaults.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

enum Key : String {
    case username
    case userid 
}

extension UserDefaults {
    
    func set<T>(_ value: T?, forKey key: Key) {
        set(value, forKey: key.rawValue)
    }
    
    func value<T>(forKey key: Key) -> T? {
        return value(forKey: key.rawValue) as? T
    }
    
}
