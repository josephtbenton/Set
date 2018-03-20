//
//  File.swift
//  Set
//
//  Created by Joseph Benton on 2/21/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    private struct CardParams {
        static let backgroundColor = UIColor.white
        static let strokeColor = UIColor.gray
        static let selectedColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        static let setColor = UIColor.green
        static let nonSetColor = UIColor.red
        static let cardBufferProp = CGFloat(0.1)
        static let cornerRadius = CGFloat(8.0)
    }
    
    var cardToDraw: SetCard?
    var selected = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var inSet: Bool? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var faceUp = false { didSet { setNeedsDisplay(); setNeedsLayout() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.clear.setFill()
        UIRectFill(rect)
        
        if let card = cardToDraw {
            drawCard(card, inside: rect)
        } else {
            drawBlankCard(inside: rect)
        }
    }
    
    func drawBlankCard(inside rect: CGRect) {
        let buffer = rect.width * CardParams.cardBufferProp
        let cardFrame = bounds.insetBy(dx: buffer, dy: buffer)
        let roundedRect = UIBezierPath(roundedRect: cardFrame, cornerRadius: CardParams.cornerRadius)
        CardParams.backgroundColor.setFill()
        CardParams.strokeColor.setStroke()
        if selected {
            CardParams.selectedColor.setFill()
        }
        if let set = inSet {
            if set {
                CardParams.setColor.setStroke()
            } else {
                CardParams.nonSetColor.setStroke()
            }
        }
        roundedRect.lineWidth = 4
        roundedRect.fill()
        roundedRect.stroke()
    }
    
    func drawCard(_ card: SetCard, inside rect: CGRect) {
        drawBlankCard(inside: rect)
        
        guard faceUp else { return }
        
        var centers: [CGPoint] = []
        
        switch card.number {
        case .one:
            let center = rect.origin.offsetBy(dx: rect.width/2, dy: rect.height/2)
            centers += [center]
        case .two:
            let center1 = rect.origin.offsetBy(dx: rect.width/2, dy: 2*rect.height/5)
            let center2 = rect.origin.offsetBy(dx: rect.width/2, dy: 3*rect.height/5)
            centers += [center1, center2]
        case .three:
            let center1 = rect.origin.offsetBy(dx: rect.width/2, dy: rect.height/3)
            let center2 = rect.origin.offsetBy(dx: rect.width/2, dy: rect.height/2)
            let center3 = rect.origin.offsetBy(dx: rect.width/2, dy: 2*rect.height/3)
            centers += [center1, center2, center3]
        }
        
        var paths: [UIBezierPath] = []
        
        for center in centers {
            switch card.symbol {
            case .diamond:
                let path = diamondPathCentered(at: center)
                paths += [path]
            case .oval:
                let path = ovalPathCentered(at: center)
                paths += [path]
            case .squiggle:
                let path = squigglePathCentered(at: center)
                paths += [path]
            }
        }
        
        switch card.color {
        case .green:
            UIColor.green.setFill()
            UIColor.green.setStroke()
        case .purple:
            UIColor.magenta.setFill()
            UIColor.magenta.setStroke()
        case .red:
            UIColor.red.setFill()
            UIColor.red.setStroke()
        }
        
        for path in paths {
            path.lineWidth = 2
            switch card.shading {
            case .open:
                path.stroke()
            case .solid:
                path.fill()
            case .striped:
                if let context = UIGraphicsGetCurrentContext() {
                    context.saveGState()
                    path.addClip()
                    for xpos in stride(from: path.bounds.minX, to: path.bounds.maxX, by: 4) {
                        let line = UIBezierPath()
                        line.move(to: CGPoint(x: xpos, y: path.bounds.minY))
                        line.addLine(to: CGPoint(x: xpos, y: path.bounds.maxY))
                        line.stroke()
                    }
                    path.stroke()
                    context.restoreGState()
                }
                
            }
        }
        
        
        
    }
    
    func ovalPathCentered(at point: CGPoint) -> UIBezierPath {
        let length: CGFloat = frame.width * 0.4
        let width: CGFloat = length / 2
        
        let path = UIBezierPath()
        path.move(to: point)
        path.move(to: path.currentPoint.offsetBy(dx: -length/2, dy: -width/2))
        path.addArc(withCenter: path.currentPoint.offsetBy(dx: 0, dy: width/2), radius: width/2, startAngle: 3*CGFloat.pi/2, endAngle: CGFloat.pi/2, clockwise: false)
        path.addLine(to: path.currentPoint.offsetBy(dx: length, dy: 0))
        path.addArc(withCenter: path.currentPoint.offsetBy(dx: 0, dy: -width/2), radius: width/2, startAngle: CGFloat.pi/2, endAngle: 3*CGFloat.pi/2, clockwise: false)
        path.close()
        return path
    }
    
    func squigglePathCentered(at point: CGPoint) -> UIBezierPath {
        let length: CGFloat = frame.width * 0.5
        let width: CGFloat = length / 3
        
        let path = UIBezierPath()
        path.move(to: point)
        path.move(to: path.currentPoint.offsetBy(dx: -length/2, dy: -width/2))
        path.addCurve(to: path.currentPoint.offsetBy(dx: length, dy: 0), controlPoint1: path.currentPoint.offsetBy(dx: length/2, dy: width/1.5), controlPoint2: path.currentPoint.offsetBy(dx: length/2, dy: -width/1.5))
        path.addLine(to: path.currentPoint.offsetBy(dx: 0, dy: width))
        path.addCurve(to: path.currentPoint.offsetBy(dx: -length, dy: 0), controlPoint1: path.currentPoint.offsetBy(dx: -length/2, dy: -width/1.5), controlPoint2: path.currentPoint.offsetBy(dx: -length/2, dy: width/1.5))
        path.close()
        return path
    }
    
    func diamondPathCentered(at point: CGPoint) -> UIBezierPath {
        let length: CGFloat = frame.width * 0.5
        let width: CGFloat = length / 3
        
        let path = UIBezierPath()
        path.move(to: point)
        path.move(to: path.currentPoint.offsetBy(dx: 0, dy: width/2))
        path.addLine(to: path.currentPoint.offsetBy(dx: -length/2, dy: -width/2))
        path.addLine(to: path.currentPoint.offsetBy(dx: length/2, dy: -width/2))
        path.addLine(to: path.currentPoint.offsetBy(dx: length/2, dy: width/2))
        path.close()
        return path
    }

    
    
}


extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        let newX = self.x + dx
        let newY = self.y + dy
        return CGPoint(x: newX, y: newY)
        
    }
}
