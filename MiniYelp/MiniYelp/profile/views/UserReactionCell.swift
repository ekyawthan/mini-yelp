

//
//  UserReactionCell.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/18/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import UIKit

class UserReactionCell: UITableViewCell {
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var reactionTypeName: UILabel!
    
    func config(with place : MiniYelpPlace, from viewed : Bool = false) {
        placeName.text = place.name
        guard !viewed else {
            reactionTypeName.text = "you viewed this place! 🙈"
            return
        }
        guard let userid = MiniYelpApp.shared.getUserId() else { return }
        let ej = place.reactions.filter{$0.type == "thump-up"}.contains{$0.userid == userid} ? " 👍" : "👎"
        reactionTypeName.text = "your reacted this place with \(ej)"

    }
    

    
}
