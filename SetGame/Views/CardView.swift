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
    }
    
    private var maxShapeDimension : CGFloat {
        return self.bounds.width / 4
    }
    
//    private var objectFrames : [CGRect] {
//        var firstDrawPointx = self.bounds.minX
//        var frames = [CGRect]()
//        if let num = num {
//            for _ in 1...num.rawValue {
//                frames.append(CGRect(x: firstDrawPointx, y: self.bounds.minY, width: maxShapeDimension, height: maxShapeDimension))
//                firstDrawPointx += maxShapeDimension + (self.bounds.width * Padding.betweenShapesProportion)
//            }
//        }
//        return frames
//    }
    
    override func draw(_ rect: CGRect) {
        
        var grid = Grid(layout: .fixedCellSize(CGSize(width: maxShapeDimension, height: maxShapeDimension)), frame: self.bounds)
        if let card = card {
          //  print(card.num.rawValue)
            print(grid.cellCount)
            grid.cellCount = card.num.rawValue
            for cellIndex in 0..<card.num.rawValue {
                //print(grid.cellCount)
                if let displayBounds = grid[cellIndex] {
                    let object = SingleShapeView(frame: displayBounds, shape: card.symbol, color: card.color, shading: card.shading)
                    self.addSubview(object)
                }
            }
        }
        
        //        for objectFrame in objectFrames {
        //            if let shape = shape, let color = color, let shading = shading {
        //                let object = SingleShapeView(frame: objectFrame, shape: shape, color: color, shading: shading)
        //                self.addSubview(object)
        //            }
        //        }
        //        createBorderAroundSelf()
    }
    
    private func createBorderAroundSelf() {
        if let width = SelectionBorder.width[self.selectState] {
            self.layer.borderColor = UIColor.blue.cgColor
            self.layer.borderWidth = width
        }
        
    }
}



extension CardView {
    struct Padding {
        static let betweenShapesProportion = CGFloat(1) / CGFloat(40)
    }
    
    
    struct SelectionBorder {
        static let width : [selectionState : CGFloat] = [.selected: CGFloat(3.0), .unselected: CGFloat(0.0)]
    }
}
