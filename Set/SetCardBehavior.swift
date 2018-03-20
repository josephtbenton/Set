//
//  CardBehavior.swift
//  Set
//
//  Created by Joseph Benton on 3/13/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import UIKit

class SetCardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    var snapBehaviors: [UISnapBehavior:SetCardView] = [:]
    
    private func push(_ item: UIDynamicItem) {
        let push  = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(2) + CGFloat(4.0).arc4random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func snap(_ item: SetCardView, to rect: CGRect) {
        let x = rect.origin.x + rect.width/2
        let y = rect.origin.y + rect.height/2
        let snap = UISnapBehavior(item: item, snapTo: CGPoint(x: x, y: y))
        snap.damping = 1
        
        self.snapBehaviors[snap] = item
        self.addChildBehavior(snap)
        
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
        animator.delegate = self
    }
}


extension SetCardBehavior: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        for (sb, cardView) in self.snapBehaviors {
            if cardView.faceUp {
                UIView.transition(
                    with: cardView,
                    duration: 0.5,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        cardView.faceUp = false
                },
                    completion: { position in return
                        UIView.transition(
                            with: cardView,
                            duration: 0.5,
                            options: [.transitionCrossDissolve],
                            animations: {
                                cardView.inSet = nil
                                cardView.selected = false
                        },
                            completion: { position in return
                                cardView.removeFromSuperview()
                        }
                        )
                    }
                )
            }
            self.snapBehaviors.removeValue(forKey: sb)
            self.removeChildBehavior(sb)
        }
    }
}


extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}













