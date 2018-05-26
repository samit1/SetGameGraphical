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
    private (set) var card: Card? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var description: String {
        guard let card = card else {return "empty"}
        
        
        return "shape: \(String(card.symbol.description )) + \(String(describing: card.color.description)) + \(String(describing: card.num.description)) + \(String(describing: card.shading.description))"
    }
    
    
    // MARK: Initialization Methods
    
    /// TODO: Fix initalization stuff
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(frame: CGRect, card: Card) {
        self.card = card
        super.init(frame: frame)
        self.contentMode = .redraw
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
    }
    
    
    // MARK: Dimensions
    
    /// A maximum dimension must be
    /// used to determine spacing in between shapes.
    /// this is a computed helper variable
    private var maxShapeDimension : CGFloat {
        return self.bounds.width / 4
    }
    
    /**
        Drawing must begin in a certain place to guarantee it will be centered
     
     ##*Scenarios*
     - One Symbol: Begin drawing at halfway - minus half of the shape width.
     - Two Symbols: Begin drawing between the quarter and half way - minus half of the shape width.
     - Three Symbols: Begin drawing between three quarters of the way - minus half of the shape width.
     */
    private var startPointX : CGFloat? {
        if let card = card {
            let halfShapeWidth = maxShapeDimension / 2
            switch card.num {
            case .one:
                return self.bounds.width / 2 - halfShapeWidth
            case .two:
                let quarter = self.bounds.width / 4
                let half = self.bounds.width / 2
                let betweenQuarterAndHalf = ((half - quarter) / 2) + quarter
                return betweenQuarterAndHalf - halfShapeWidth
            case .three:
                let quarter = self.bounds.width / 4
                return quarter - halfShapeWidth
            }
        }
        return nil
    }
    
    /// Computes object frames required for each symbol
    
    private var objectFrames : [CGRect] {
        var firstDrawPointx : CGFloat?
        var firstDrawPointY: CGFloat?
        var frames = [CGRect]()
        
        if let card = card {
            firstDrawPointx = startPointX
            firstDrawPointY = (self.bounds.height) / 2 - (maxShapeDimension / 2)
        
            for _ in 1...card.num.rawValue {
                frames.append(CGRect(x: firstDrawPointx!, y: firstDrawPointY!, width: maxShapeDimension, height: maxShapeDimension))
                firstDrawPointx! += maxShapeDimension + (self.bounds.width * Padding.betweenShapesProportion)
            }
        }
        return frames
    }
    
    override func draw(_ rect: CGRect) {
        
        for objectFrame in objectFrames {
            if let card = card {
                let object = SingleShapeView(frame: objectFrame, shape: card.symbol, color: card.color, shading: card.shading)
                self.addSubview(object)
            }
        }
    }
    
    
    
}



private struct Padding {
    static let betweenShapesProportion = CGFloat(1) / CGFloat(40)
}

    

//
//
//    struct SelectionBorder {
//        static let width : [selectionState : CGFloat] = [.selected: CGFloat(3.0), .unselected: CGFloat(0.5)]
//    }
//
//    struct SelectionColor {
//        static let color : [selectionState : CGColor] = [.selected: UIColor.blue.cgColor, .unselected: UIColor.black.cgColor]
//    }

