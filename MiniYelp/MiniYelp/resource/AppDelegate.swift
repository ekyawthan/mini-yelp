//
//  AppDelegate.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppGlobalApperance()
        loginAnonymouslyIfNeeded()
        return true
    }
    
  

    private func setupAppGlobalApperance() {
        UINavigationBar.appearance().tintColor = UIColor.primaryColor
    }
    
    func loginAnonymouslyIfNeeded() {
        guard let userid =  MiniYelpApp.shared.getUserId() else {
            login()
            return
        }
        user(by: userid)
    }
    
    fileprivate func login() {
        let resourceType = MiniYelpResoureType.login
        URLSession.shared.load(resourceType) { (result : Result<User>) in
            switch result {
            case .failer(let error): ()
            case .succeed(let data):
                MiniYelpApp.shared.updateCurrentUser(user: data)
            }
        }
    }
    
    fileprivate func user(by id : String) {
        let resourceType = MiniYelpResoureType.user(withUserid: id)
        URLSession.shared.load(resourceType) { (result : Result<User>) in
            switch result {
            case .failer(let error):()
            case .succeed(let data):
                MiniYelpApp.shared.updateCurrentUser(user: data)
            }
        }
    }
}

