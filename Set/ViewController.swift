//
//  ViewController.swift
//  Set
//
//  Created by Joseph Benton on 2/2/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = SetGame()
    
    @IBOutlet weak var deal3Button: UIButton!
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet var cardViews: [UIButton]!
    
    @IBAction func DealThreeCards(_ sender: UIButton) {
        if game.drawnCards.count + 3 <= cardViews.count && game.deckSize - 3 >= 0 {
            game.dealCards(n: 3)
            updateViewFromModel()
        }
    }
    
    @IBAction func selectCard(_ sender: UIButton) {
        if let cardIndex = cardViews.index(of: sender) {
            game.touchCard(at: cardIndex)
            updateViewFromModel()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        updateViewFromModel()
    }
    
    
    func updateViewFromModel() {
        deckLabel.text = "Deck: \(game.deckSize)"
        setsLabel.text = "Sets: \(game.matches)"
        
        clearButtonViews()
        
        for index in game.drawnCards.indices {
            let button = cardViews[index]
            let card = game.drawnCards[index]
            if game.isSelected(at: index) {
                if let isSet = game.isInSet(at: index) {
                    if isSet {
                        button.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    } else {
                        button.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    }
                } else {
                    button.layer.borderColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
                }
            } else {
                button.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            }
            
            button.layer.cornerRadius = 8.0
            button.layer.borderWidth = 3.0
            button.layer.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
            button.setAttributedTitle(attributedString(from: card), for: .normal)
            
            button.isEnabled = true
        }
        
        var replaceSet = false
        if let ss = game.setSelected {
            replaceSet = ss
        }
        if game.deckSize < 3 || (game.drawnCards.count > cardViews.count - 3 && !replaceSet) {
            deal3Button.isEnabled = false
        } else {
            deal3Button.isEnabled = true
        }
        
    }
    
    func clearButtonViews() {
        for button in cardViews {
            button.setAttributedTitle(nil, for: .normal)
            button.layer.cornerRadius = 8.0
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1.0
            button.layer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            button.isEnabled = false
        }
    }
    
    func attributedString(from card: Card) -> NSAttributedString {
        let diamonds = "▲▲▲"
        let ovals = "●●●"
        let squiggles = "■■■"
        
        var symbolString = ""
        var symbolStroke = -6
        var symbolFillAlpha: CGFloat
        
        var cardColor: UIColor
        
        switch card.symbol {
        case .diamond:
            symbolString = diamonds
        case .oval:
            symbolString = ovals
        case .squiggle:
            symbolString = squiggles
        }
        
        switch card.number {
        case .one:
            symbolString = String(symbolString.prefix(1))
        case .two:
            symbolString = String(symbolString.prefix(2))
        case .three:
            symbolString = String(symbolString.prefix(3))
        }
        
        switch card.color {
        case .green:
            cardColor = UIColor.green
        case .purple:
            cardColor = UIColor.magenta
        case .red:
            cardColor = UIColor.red
        }
        
        switch card.shading {
        case .open:
            symbolFillAlpha = 0.0
            symbolStroke = 5
        case .striped:
            symbolFillAlpha = 0.5
            symbolStroke = -5
        case .solid:
            symbolFillAlpha = 1.0
            symbolStroke = 0
        }
        
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeColor: cardColor,
            .strokeWidth: symbolStroke,
            .foregroundColor: cardColor.withAlphaComponent(symbolFillAlpha)
            ]
        
        
        return NSAttributedString(string: symbolString, attributes: attributes)
        
    }

}

