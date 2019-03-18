
//
//  PlaceDetailPage.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/15/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import UIKit

class PlaceDetailPage: UIViewController {
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberOfView: UIButton!
    @IBOutlet weak var numberOfThumpUp: UIButton!
    @IBOutlet weak var numberOfThumpDown: UIButton!
    @IBOutlet weak var thumpUpButton: UIButton!
    @IBOutlet weak var thumpDownButton: UIButton!
    
    var place : PlaceDetail?
    var miniyelpPlace : MiniYelpPlaceDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        updateViewCount(with: place)
        addressLabel.text = place?.formattedAddress
        nameLabel.text = place?.name
    }

    
    func updateViewCount(with place : PlaceDetail?) {
        guard let place = place else { return }
        guard let userid = MiniYelpApp.shared.getUserId() else { return }
        let param  : [String : String ] = [
            "userid":userid,
            "google_id":place.id,
            "name":place.name,
            "placeId":place.placeID,
            "priceLevel":"1",
            "rating":"\(place.rating)",
            "reference":"adslfkasdjf",
            "userRatingsTotal":"\(place.userRatingsTotal)"
            ]
        let resouceType = MiniYelpResoureType.updateViewCount(body: param)
        URLSession.shared.load(resouceType) { (result : Result<MiniYelpPlace>) in
            switch result {
            case .failer(_):()
            case .succeed(let value):
                DispatchQueue.main.async {
                    self.setupReactionView(with: value)
                  
                }
               
            }
            
        }
        
    }
    
    
    @IBAction func onThumpUp(_ sender: Any) {
       react(with: "thump-up")
        self.thumpUpButton.backgroundColor = .green
        self.thumpDownButton.isUserInteractionEnabled = false
        self.thumpUpButton.isUserInteractionEnabled = false
    }
    
    @IBAction func onThumpDown(_ sender: Any) {
        react(with: "thump-down")
        let count = (Int(thumpDownButton.title(for: .normal) ?? "0") ?? 0 )
    
        thumpDownButton.setTitle("\(count + 1)", for: .normal)
        self.thumpDownButton.backgroundColor = .green
        self.thumpDownButton.isUserInteractionEnabled = false
        self.thumpUpButton.isUserInteractionEnabled = false
    }
    
    func setupReactionView(with place : MiniYelpPlace) {
        
        let viewCount = place.reactions.filter{$0.type == "view"}
        let upCount = place.reactions.filter{$0.type == "thump-up"}
        let downCount = place.reactions.filter{$0.type == "thump-down"}
        self.numberOfView.setTitle("\(viewCount.count)", for: .normal)
        self.numberOfThumpUp.setTitle("\(upCount.count)", for: .normal)
        self.numberOfThumpDown.setTitle("\(downCount.count)", for: .normal)
        guard let userid = MiniYelpApp.shared.getUserId() else { return }
        let upped = upCount.contains{$0.userid == userid}
        let downed = downCount.contains{$0.userid == userid }
        if upped {
            self.thumpUpButton.backgroundColor = .green
            self.thumpDownButton.isUserInteractionEnabled = false
            self.thumpUpButton.isUserInteractionEnabled = false
        }
        else if downed {
            self.thumpDownButton.backgroundColor = .green
            self.thumpDownButton.isUserInteractionEnabled = false
            self.thumpUpButton.isUserInteractionEnabled = false
        }
        
        
        
    }
    func react(with type : String) {
        guard let placeID = place?.placeID else { return }
        guard let userid = MiniYelpApp.shared.getUserId() else { return }
        let param : [String : String] = [
            "reactionType": type,
            "userid":userid,
            "placeId":placeID ]
        
        let resourceType = MiniYelpResoureType.updateReaction(body: param)
        URLSession.shared.load(resourceType) { (result : Result<Reaction>) in
            print(result)
        }
    }
}

