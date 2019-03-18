//
//  MiniYelpApp.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

class MiniYelpApp {
    static let shared = MiniYelpApp()
    private var user : User?
    private var token : String?
    
    private init() {}
    
    func updateCurrentUser(user : User) {
        self.user = user
        store(userid: user.id)
        self.token = user.token
    }
    func store(userid id : String) {
        UserDefaults().set(id, forKey: .userid)
    }
    
    func getUserId() -> String? {
        return UserDefaults().value(forKey: .userid) 
    }
    
    func getUser() -> User? {
        return self.user
    }
}
