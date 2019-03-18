//
//  GooglePlaceManager.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation
import CoreLocation

protocol GooglePlaceDelegate : class  {
    func didCompleteGooglePlaceDetail(with place : [Place], and placeDetail : [PlaceDetail])
    func didCompleteGooglePlace(with error : Error)
}

class GooglePlaceManager {
    
    var result : [PlaceDetail] = []
    
    weak var delegate : GooglePlaceDelegate?
    init(with delegate : GooglePlaceDelegate?) {
        self.delegate = delegate
    }
    func fetchDetail(on places : [Place]) {
        result = []
        let group = DispatchGroup()
        places.forEach{
            self.getPlaceDetail(with: $0.placeID, group: group)
        }
        group.notify(queue: .main) {
            // notify
            print("complete with \(places.count) and \(self.result.count)")
            self.delegate?.didCompleteGooglePlaceDetail(with: places, and: self.result)
        }
    }
    func getPlaceDetail(with placeId : String, group :  DispatchGroup) {
        group.enter()
        let param = ["placeid" : placeId]
        let resourceType = MiniYelpResoureType.googlePlaceDetail(query: param)
        URLSession.shared.load(resourceType) { (result : Result<PlaceDetailResult>) in
            switch result {
            case .failer(_):()
            case .succeed(let data):
                let sentimentRank = MiniYelpRecommender().sentimentAnalysis(on: data.result)
                var value = data.result
                value.sentimentingRanking = sentimentRank
                self.result.append(value)
            }
            group.leave()
        }
    }
    
    func getPlace(with keyword : String = "", on location : CLLocation  ) {
        
        let query = [
            "location" :String(location.coordinate.latitude) + "," + String(location.coordinate.longitude),
            "radius" : "15000",
            "type": "restaurant",
            "keyword" : keyword,
            "key" : "AIzaSyAzhyq0ppjSpZwxDC2IZKwUfxHFLo0hfmE"
        ]
        let resoucetype = MiniYelpResoureType.googlePlace(query: query)
        URLSession.shared.load(resoucetype) { [weak self] (result : Result<PlaceSearch>) in
            switch result {
            case .failer(let error) :
                self?.delegate?.didCompleteGooglePlace(with:error)
            case .succeed(let data):
                guard let value = data.results else { return }
                self?.fetchDetail(on: value)
            }
        }
    }
    
    
}
