//
//  CardView.swift
//  SetGame
//
//  Created by Sami Taha on 5/20/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

class CardView: UIView {
    private (set) var card: Card?
    private var shape : Card.Symbol?
    private var color : Card.Color?
    private var num: Card.Number?
    private var shading: Card.Shading?
    
    var selectState : selectionState = .unselected  { didSet {setNeedsLayout(); setNeedsDisplay() } }
    
    
    enum selectionState {
        case selected
        case unselected
    }
    
    
    
    override var description: String {
        return "shape: \(String(describing: shape)) + \(String(describing: color)) + \(String(describing: num)) + \(String(describing: shading))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, card: Card) {
        self.card = card
        self.shape = card.symbol
        self.color = card.color
        self.num = card.num
        self.shading = card.shading
        
        super.init(frame: frame)
        self.contentMode = .redraw
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
        
    }
    
    private var maxShapeDimension : CGFloat {
        return self.bounds.width / 4
    }
    
    private var startPointX : CGFloat? {
        var beginPoint = 0
        if let card = card {
            switch card.num {
            case .one:
                return self.bounds.width / 2
            case .two:
                let quarter = self.bounds.width / 4
                let half = self.bounds.width / 2
                let betweenQuarterAndHalf = ((half - quarter) / 2) + quarter
                let halfShapeWidth = maxShapeDimension / 2
                return betweenQuarterAndHalf - halfShapeWidth
            case .three:
                let quarter = self.bounds.width / 4
                let halfShapeWith = maxShapeDimension / 2
                return quarter - halfShapeWith
                
            }
        }
        return nil
    }
    
    private var objectFrames : [CGRect] {
        var firstDrawPointx : CGFloat?
        var firstDrawPointY: CGFloat?

        if let card = card {
            switch card.num {
            case .one:
                let half = self.bounds.width / 2
                let halfShapeWidth = maxShapeDimension / 2
                firstDrawPointx = half - halfShapeWidth
            case .two:
                let quarter = self.bounds.width / 4
                let half = self.bounds.width / 2
                let betweenQuarterAndHalf = ((half - quarter) / 2) + quarter
                let halfShapeWidth = maxShapeDimension / 2
                firstDrawPointx = betweenQuarterAndHalf - halfShapeWidth
            case .three:
                let quarter = self.bounds.width / 4
                let halfShapeWith = maxShapeDimension / 2
                firstDrawPointx = quarter - halfShapeWith
            }
            firstDrawPointY = (self.bounds.height) / 2 - (maxShapeDimension / 2)
        }
        
        var frames = [CGRect]()
        if let num = num {
            for _ in 1...num.rawValue {
                frames.append(CGRect(x: firstDrawPointx!, y: firstDrawPointY!, width: maxShapeDimension, height: maxShapeDimension))
                firstDrawPointx! += maxShapeDimension + (self.bounds.width * Padding.betweenShapesProportion)
            }
        }
        return frames
    }
    
    override func draw(_ rect: CGRect) {
        for objectFrame in objectFrames {
            if let shape = shape, let color = color, let shading = shading {
                let object = SingleShapeView(frame: objectFrame, shape: shape, color: color, shading: shading)
                self.addSubview(object)
            }
        }
        createBorderAroundSelf()
    }
    
    private func createBorderAroundSelf() {
        if let width = SelectionBorder.width[self.selectState] {
            self.layer.borderWidth = width
        }
        
        if let color = SelectionColor.color[self.selectState] {
            self.layer.borderColor = color
        }
        
    }
}



extension CardView {
    struct Padding {
        static let betweenShapesProportion = CGFloat(1) / CGFloat(40)
    }
    
    
    struct SelectionBorder {
        static let width : [selectionState : CGFloat] = [.selected: CGFloat(3.0), .unselected: CGFloat(0.5)]
    }
    
    struct SelectionColor {
        static let color : [selectionState : CGColor] = [.selected: UIColor.blue.cgColor, .unselected: UIColor.black.cgColor]
    }
}
