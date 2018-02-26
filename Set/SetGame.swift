//
//  SetGame.swift
//  Set
//
//  Created by Joseph Benton on 2/5/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import Foundation
import GameplayKit

class SetGame {
    var cards: [Card]
    var drawnCards: [Card]
    var selectedCards: [Card]
    var setSelected: Bool?
    var matches: Int
    var deckSize: Int {
        get {
            return cards.count
        }
    }
    let initialCards = 12
    
    init() {
        cards = []
        drawnCards = []
        selectedCards = []
        matches = 0
        
        for number in SetNumber.values {
            for color in SetColor.values {
                for shading in SetShading.values {
                    for symbol in SetSymbol.values {
                        cards.append( Card(symbol: symbol, color: color, number: number, shading: shading) )
                    }
                }
            }
        }
        shuffle()
        print("\(deckSize) cards added to deck")
        self.dealCards(n: self.initialCards)

    }
    
    func touchCard(at index: Int) {
        let card = drawnCards[index]
        
        if let setExists = setSelected {
            if setExists {
                for c in selectedCards {
                    drawnCards.remove(at: drawnCards.index(of: c)!)
                }
                if selectedCards.contains(card) {
                    selectedCards.removeAll()
                    if drawnCards.count < initialCards {
                        dealCards(n: 3)
                    }
                    return
                }
            }
            selectedCards.removeAll()

        }
        
        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.index(of: card)!)
        } else {
            selectedCards.append(card)

        }
        
        checkSet()
        if drawnCards.count < initialCards {
            dealCards(n: 3)
        }
    }
    
    func isSelected(at index: Int) -> Bool {
        let card = drawnCards[index]
        return selectedCards.contains(card)
    }
    
    func isInSet(at index: Int) -> Bool? {
        if isSelected(at: index) {
            return setSelected
        } else {
            return nil
        }
    }
    
    func checkSet() {
        self.setSelected = isSet(cards: selectedCards)
    }
    
    func dealCards(n: Int) {
        if let setExists = setSelected {
            if setExists {
                for c in selectedCards {
                    drawnCards.remove(at: drawnCards.index(of: c)!)
                }
            }
            selectedCards.removeAll()
        }
        if deckSize >= n {
            for _ in 1...n {
                if let card = cards.popLast() {
                    drawnCards.append(card)
                }
            }
        }
    }
    
    func isSet(cards: [Card]) -> Bool? {
        guard
            self.selectedCards.count == 3 else { return nil }
        
        guard
            match(cards: cards, on: { c in c.color.hashValue }),
            match(cards: cards, on: { c in c.number.hashValue }),
            match(cards: cards, on: { c in c.shading.hashValue }),
            match(cards: cards, on: { c in c.symbol.hashValue })
        else { return false }
        matches += 1
        return true
    }
    
    func shuffle() {
        self.cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! Array<Card>

    }
    
    func shuffleDrawnCards() {
        self.drawnCards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: drawnCards) as! Array<Card>

    }
    
    func match(cards: [Card], on param: (_: Card) -> Int) -> Bool {
        // maps the specified attribute of each card into a set with no duplicates,
        // then checks that it there is only one occurance of attribute, or all unique attributes
        let attributeAppearances = Set(cards.flatMap(param))
        return attributeAppearances.count == 1 || attributeAppearances.count == cards.count
    }
}
