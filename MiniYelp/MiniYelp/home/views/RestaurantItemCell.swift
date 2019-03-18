//
//  RestaurantItemCell.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import UIKit

class RestaurantItemCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var sentimentRankingLabel: UILabel!
    @IBOutlet weak var googleRankingLabel: UILabel!
    
    func config(with place : PlaceDetail) {
        name.text = place.name
        addressLabel.text = place.formattedAddress
        sentimentRankingLabel.text = "Senti-Ranking : \(place.sentimentingRanking)"
        googleRankingLabel.text = "Google : \(place.rating)"
    }
}
