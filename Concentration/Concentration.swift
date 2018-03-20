//
//  Concentration.swift
//  Concentration
//
//  Created by Joseph Benton on 1/29/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import Foundation
import GameplayKit

class Concentration {
    
    var cards = [ConcentrationCard]()
    var indexOfOneAndOnlyFaceUpCard: Int?
    var flipCount = 0
    var score = 0
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    if cards[index].hasBeenFlipped { score -= 1}
                    if cards[matchIndex].hasBeenFlipped { score -= 1 }
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipdownIndex in cards.indices {
                    cards[flipdownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = ConcentrationCard()
            cards += [card, card]
        }
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! Array<ConcentrationCard>
    }
    
}
