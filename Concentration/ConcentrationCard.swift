//
//  Card.swift
//  Concentration
//
//  Created by Joseph Benton on 1/29/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import Foundation

struct ConcentrationCard {
    var isFaceUp = false {
        willSet {
            if isFaceUp, !newValue {
                hasBeenFlipped = true
            }
        }
    }
    var isMatched = false
    var hasBeenFlipped = false
    var identifier: Int
    
    static var identifierFactory = 0
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init () {
        self.identifier = ConcentrationCard.getUniqueIdentifier()
    }
}
