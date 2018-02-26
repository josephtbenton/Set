//
//  GraphicalSetViewController.swift
//  Set
//
//  Created by Joseph Benton on 2/20/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import UIKit

class GraphicalSetViewController: UIViewController {
    var game = SetGame()
    
    @IBOutlet weak var deal3Button: UIButton!
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var cardView: UIView!

    var grid: Grid!
    
    private struct GridParams {
        static let aspectRatio = CGFloat(0.7142)
        
    }
    
    @IBAction func DealThreeCards(_ sender: UIButton) {
        if game.deckSize - 3 >= 0 {
            game.dealCards(n: 3)
            updateViewFromModel()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        updateViewFromModel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeDown(sender:)))
        swipeGesture.direction = .down
        cardView.addGestureRecognizer(swipeGesture)
        
        let twistGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.handleTwist(sender:)))
        cardView.addGestureRecognizer(twistGesture)
        
        updateViewFromModel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotated() {
        updateViewFromModel()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let cv = sender.view as? CardView {
            if let card = cv.cardToDraw {
                if let index = game.drawnCards.index(of: card) {
                    game.touchCard(at: index)
                }
            }
        }
        updateViewFromModel()
    }
    
    @objc func handleSwipeDown(sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            if game.deckSize - 3 >= 0 {
                game.dealCards(n: 3)
                updateViewFromModel()
            }
        }
    }
    
    @objc func handleTwist(sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            game.shuffleDrawnCards()
            updateViewFromModel()
        }
    }
    
    
    
    func updateViewFromModel() {
        deckLabel.text = "Deck: \(game.deckSize)"
        setsLabel.text = "Sets: \(game.matches)"
        
        for card in cardView.subviews {
            card.removeFromSuperview()
        }
        
        
        grid = Grid(layout: .aspectRatio(GridParams.aspectRatio), frame: cardView.bounds)

        grid.cellCount = game.drawnCards.count
        for index in game.drawnCards.indices {
            if let frame = grid[index] {
                
                let cv = CardView(frame: frame)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
                cv.addGestureRecognizer(tapGesture)
                cv.cardToDraw = game.drawnCards[index]
                if game.isSelected(at: index) {
                    cv.selected = true
                }
                cv.inSet = game.isInSet(at: index)
                
                cardView.addSubview(cv)
            }
        }
    }
    

    
    
    
    
}
