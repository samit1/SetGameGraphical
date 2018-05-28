//
//  CardView.swift
//  SetGame
//
//  Created by Sami Taha on 5/20/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

/// The view responsible for displaying a single card

@IBDesignable
class SetCardView: CardView {
    
    /// The card that is displayed
    var card: Card? {
        didSet {
            self.removeAllSubviews()
            setNeedsDisplay()
        }
    }
    
    override var frame: CGRect {
        didSet {
            print("set")
        }
    }
    
    override var description: String {
        guard let card = card else {return "empty"}
        
        
        return "shape: \(String(card.symbol.description )) + \(String(describing: card.color.description)) + \(String(describing: card.num.description)) + \(String(describing: card.shading.description))"
    }
    
    
    // MARK: Dimensions, Positioning, and Spacing
    
    /// A maximum dimension must be
    /// used to determine spacing in between shapes.
    /// this is a computed helper variable
    private var maxShapeDimension : CGFloat {
        return self.frame.width / 4
    }
    
    /**
     Drawing must begin in a certain place to guarantee it will be centered
     
     ##*Scenarios*
     - One Symbol: Begin drawing at halfway - minus half of the shape width.
     - Two Symbols: Begin drawing between the quarter and half way - minus half of the shape width.
     - Three Symbols: Begin drawing between three quarters of the way - minus half of the shape width.
     */
    private var startPointX : CGFloat?   {
        if let card = card {
            let halfShapeWidth = maxShapeDimension / 2
            switch card.num {
            case .one:
                return self.frame.width / 2 - halfShapeWidth
            case .two:
                let quarter = self.frame.width / 4
                let half = self.frame.width / 2
                let betweenQuarterAndHalf = ((half - quarter) / 2) + quarter
                return betweenQuarterAndHalf - halfShapeWidth
            case .three:
                let quarter = self.frame.width / 4
                return quarter - halfShapeWidth
            }
        }
        return nil
    }
    
    /// Computes object frames required for each symbol.
    /// The drawing begins at the startPoint and varies
    /// based on the number of suymbols that need to be displayed
    
    private var objectFrames : [CGRect] {
        var firstDrawPointx = CGFloat()
        var firstDrawPointY = CGFloat()
        var frames = [CGRect]()
        
        if let card = card, let startPointX = startPointX {
            
            firstDrawPointx = startPointX
            firstDrawPointY = (self.frame.height) / 2 - (maxShapeDimension / 2)
            
            for _ in 1...card.num.rawValue {
                frames.append(CGRect(x: firstDrawPointx, y: firstDrawPointY, width: maxShapeDimension, height: maxShapeDimension))
                firstDrawPointx += maxShapeDimension + (self.frame.width * Padding.betweenShapesProportion)
            }
        }
        return frames
    }
    
    /// Draws the front of the card
    /// and adds it to the subview
    
    override func drawFront() {
        for objectFrame in objectFrames {
            if let card = card {
                let object = SingleShapeView(frame: objectFrame, shape: card.symbol, color: card.color, shading: card.shading)
                self.addSubview(object)
                
            }
        }
//       self.backgroundColor = UIColor.white
    }

    /// Draws the back of the card
    /// ...which is just setting the view to a color
    override func drawBack() {
        self.removeAllSubviews()
        self.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
    }
    /// Create a random SetCardView
    /// This is strictly for use of @IBDesignable and @IBInspectable funtionalities
    static func generateRandomCard() -> Card {
        let color = Card.Color.all.index(Card.Color.all.startIndex, offsetBy: Card.Color.all.count.randIndex)
        let symbol = Card.Symbol.all.index(Card.Symbol.all.startIndex, offsetBy: Card.Symbol.all.count.randIndex)
        let number = Card.Number.all.index(Card.Number.all.startIndex, offsetBy: Card.Number.all.count.randIndex)
        let shading = Card.Shading.all.index(Card.Shading.all.startIndex, offsetBy: Card.Shading.all.count.randIndex)
        let card = Card(num: Card.Number.all[number], symbol: Card.Symbol.all[symbol], shading: Card.Shading.all[shading], color: Card.Color.all[color])
        return card
    }
}

private struct Padding {
    static let betweenShapesProportion = CGFloat(1) / CGFloat(40)
}



