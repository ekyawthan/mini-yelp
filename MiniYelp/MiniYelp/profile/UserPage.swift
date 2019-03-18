//
//  UserPage.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import UIKit

enum UserReactionViewType : Int {
    case history = 0
    case reacted
}

class UserPage: UIViewController {
    
    @IBOutlet weak var userReactionView: UITableView!
    var userReactionViewType : UserReactionViewType = .history
    var viewed : [MiniYelpPlace] = []
    var reacted : [MiniYelpPlace] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        self.prapareViews()
        guard let userid = MiniYelpApp.shared.getUserId() else { return }
        user(by: userid)
    }
    
    fileprivate func user(by id : String) {
        let resourceType = MiniYelpResoureType.user(withUserid: id)
        URLSession.shared.load(resourceType) { (result : Result<User>) in
            switch result {
            case .failer(_):()
            case .succeed(let data):
                MiniYelpApp.shared.updateCurrentUser(user: data)
                let viewedId = data.reactions.filter{$0.type == "view"}.map{$0.restaurantID}
                let reactIDs = data.reactions.filter{$0.type != "view" }.map{$0.restaurantID}
                self.fetchUserReaction(from: viewedId, isViewed: true)
                self.fetchUserReaction(from: reactIDs)
            }
        }
    }
    
    fileprivate func fetchUserReaction(from ids : [String], isViewed : Bool = false) {
   
        let resource = MiniYelpResoureType.byBatch(ids: ["ids" : ids.joined(separator: ",")])
        URLSession.shared.load(resource) { (result : Result<UserReactedPlace>) in
            switch result {
            case .failer(_):()
            case .succeed(let value):
                if isViewed{
                    self.viewed = value.result
                }else {
                    self.reacted = value.result
                }
                DispatchQueue.main.async {
                    self.userReactionView.reloadData()
                }
                
            }
        }
    }
    
}

extension UserPage {
    @IBAction func shouldToggleReactview(_ sender: UISegmentedControl) {
        guard let viewType = UserReactionViewType(rawValue: sender.selectedSegmentIndex) else { return }
        self.userReactionViewType = viewType
        self.userReactionView.reloadData()
    }
}

extension UserPage  {
    fileprivate func prapareViews() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        userReactionView.delegate = self
        userReactionView.dataSource = self
        userReactionView.estimatedRowHeight = 85
        userReactionView.rowHeight = UITableView.automaticDimension
        userReactionView.tableFooterView = UIView(frame: .zero)
    }
}

extension UserPage : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "UserReactionCell", for: indexPath) as? UserReactionCell else { return UITableViewCell() }
        let data = userReactionViewType == .reacted ? self.reacted[indexPath.row] : self.viewed[indexPath.row]
        cell.config(with: data, from: userReactionViewType == .history)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReactionViewType == .reacted ? self.reacted.count : self.viewed.count
    }
}
