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
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var drawnCardsView: UIView!
    @IBOutlet weak var deckView: UIView!
    @IBOutlet weak var discardView: UIView!
    @IBOutlet weak var discardPile: SetCardView?
    var cardViews: [SetCardView] = []
    
    var grid: Grid!
    
    lazy var animator = UIDynamicAnimator(referenceView: drawnCardsView)
    lazy var cardBehavior = SetCardBehavior(in: animator)
    
    
    private struct Params {
        static let aspectRatio = CGFloat(0.7142)
    }
    
    
    @IBAction func DealThreeCards() {
        game.dealCards(n: 3)
        updateViewFromModel()
    }
    
    
    @IBAction func newGame() {
        cardViews = []
        drawnCardsView.subviews.forEach({ $0.removeFromSuperview() })
        game = SetGame()
        updateViewFromModel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let twistGesture = UIRotationGestureRecognizer(target: self, action: #selector(self.handleTwist(sender:)))
        drawnCardsView.addGestureRecognizer(twistGesture)
        
        let deck = SetCardView(frame: deckView.frame)
        let discard = SetCardView(frame: discardView.frame)
        discardPile = discard
        deckView.addSubview(deck)
        discardView.addSubview(discard)
        
        let drawCardsGesture = UITapGestureRecognizer(target: self, action: #selector(self.DealThreeCards))
        deckView.addGestureRecognizer(drawCardsGesture)
        
        newGame()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func rotated() {
        updateViewFromModel()
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if let cv = sender.view as? SetCardView {
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
            DealThreeCards()
        }
    }
    
    
    @objc func handleTwist(sender: UIRotationGestureRecognizer) {
        if sender.state == .ended {
            game.shuffleDrawnCards()
            updateViewFromModel()
        }
    }
    
    
    func updateViewFromModel() {
        print("Cards on table \t \(game.drawnCards.count)")
        
        deckLabel.text = "Deck: \(game.deckSize)"
        setsLabel.text = "Sets: \(game.matches)"
        
        grid = Grid(layout: .aspectRatio(Params.aspectRatio), frame: drawnCardsView.bounds)
        grid.cellCount = game.drawnCards.count
        
        let deckRect = drawnCardsView.convert(deckView.frame, from: deckView.superview!)
        let setsRect = drawnCardsView.convert(discardPile!.frame, from: discardPile!.superview!)
        
        for card in game.undrawnCards {
            let cv = createCardView(from: card, at: deckRect)
            cardViews.append(cv)
            drawnCardsView.addSubview(cv)
        }
        
        for cardView in cardViews  {
            let card = cardView.cardToDraw!
            if let index = game.drawnCards.index(of: card) {
                cardView.selected = game.isSelected(at: index)
                cardView.inSet = game.isInSet(at: index)
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.6,
                    delay:  log(Double(index + 1)) * 0.1, // stagger card dealing animation
                    options: [],
                    animations: { [unowned self] in
                        cardView.frame = self.grid[index]!
                    },
                    completion: { _ in
                        if !cardView.faceUp {
                            UIView.transition(
                                with: cardView,
                                duration: 0.5,
                                options: [.transitionFlipFromLeft],
                                animations: {
                                    cardView.faceUp = true
                            },
                                completion: { position in return }
                            )
                        }
                }
                )
            } else {
                self.cardViews.remove(at: self.cardViews.index(of: cardView)!)
                cardView.layer.zPosition = 1
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.3,
                    delay:  0,
                    options: [.curveLinear],
                    animations: {
                        cardView.bounds = setsRect
                },
                    completion: { position in
                        self.cardBehavior.addItem(cardView)
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                            self.cardBehavior.removeItem(cardView)
                            self.cardBehavior.snap(cardView, to: setsRect)
                            
                        })
                }
                )
                
            }
        }
    }
    
    
    func createCardView(from card: SetCard, at frame: CGRect) -> SetCardView {
        let cv = SetCardView(frame: frame)
        cv.cardToDraw = card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        cv.addGestureRecognizer(tapGesture)
        return cv
    }
}

