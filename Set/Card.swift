//
//  Card.swift
//  Set
//
//  Created by Joseph Benton on 2/5/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import Foundation

struct Card {
    let symbol: SetSymbol
    let color: SetColor
    let number: SetNumber
    let shading: SetShading
}

enum SetSymbol {
    case diamond, squiggle, oval
    
    static let values: [SetSymbol] = [.diamond, .squiggle, .oval]
}

enum SetColor {
    case red, green, purple
    
    static let values: [SetColor] = [.red, .green, .purple]
}

enum SetNumber {
    case one, two, three
    
    static let values: [SetNumber] = [.one, .two, .three]
}

enum SetShading {
    case solid, striped, open
    
    static let values: [SetShading] = [.solid, .striped, .open]
}


extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.symbol == rhs.symbol && lhs.color == rhs.color && lhs.number == rhs.number && lhs.shading == rhs.shading
    }
}
