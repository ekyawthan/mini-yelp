//
//  MiniYelpRecommender.swift
//  MiniYelp
//
//  Created by Mong, Kyaw on 3/17/19.
//  Copyright © 2019 Mong, Kyaw. All rights reserved.
//

import Foundation

class MiniYelpRecommender {
    private func bow(text: String) -> [String: Double] {
        var bagOfWords = [String: Double]()
        
        let tagger = NSLinguisticTagger(tagSchemes: [.tokenType], options: 0)
        let range = NSRange(location: 0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        tagger.string = text.lowercased()
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .tokenType, options: options) { _, tokenRange, _ in
            let word = (text as NSString).substring(with: tokenRange)
            if bagOfWords[word] != nil {
                bagOfWords[word]! += 1
            } else {
                bagOfWords[word] = 1
            }
        }
        
        return bagOfWords
    }
    

    func sentimentAnalysis(on place : PlaceDetail) -> Int64 {
        var result : [Int64] = []
        guard let reviews = place.reviews else { return 0 }
        for review in reviews {
            let bagOfWords = self.bow(text: review.text)
            guard let prediction = try? MySentenceClassifier().prediction(text: bagOfWords) else { continue }
            let sorted = prediction.starsProbability.sorted { $0.value > $1.value}
            guard let rankedValue = sorted.first?.key else { continue }
            result.append(rankedValue)
        }
        guard result.count > 0 else { return 0 }
        guard let mostFrequent = result.mostFrequent() else { return 0 }
        return mostFrequent
    }

}
