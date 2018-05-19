//
//  GridView.swift
//  SetGame
//
//  Created by Sami Taha on 5/17/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

class GridView: UIView {
    var grid = Grid(layout: .aspectRatio(CGFloat(8/5)))
    
    
    
    override func draw(_ rect: CGRect) {
        grid.frame = self.frame
        for card in 0...itemsToDisplay {
        
            if let display = grid[card] {
                
                for path in bezierPathForSymbol(for: .diamond, numberOfPaths: 3, in: display) {
                    //                var path = bezierPathForSymbol(for: .diamond, in: grid[1]!)
                    //                path = UIBezierPath(rect: grid[1]!)
                    var roundedRectLayer = CAShapeLayer()
                    
                    roundedRectLayer.path = path?.cgPath
                    roundedRectLayer.fillColor = UIColor.brown.cgColor
                    roundedRectLayer.strokeColor = UIColor.red.cgColor
                    roundedRectLayer.lineWidth = 3.0
                    self.layer.addSublayer(roundedRectLayer)
                    
                    path?.fill()
                    
                }
                
            }
            
            //            let roundedRect = UIBezierPath(rect: grid[0])
            
        }
    }
    
    
    private func bezierPathForSymbol(for symbol : Symbol, numberOfPaths: Int, in rect: CGRect ) -> [UIBezierPath?] {
        var shapeGrid = Grid(layout: .dimensions(rowCount: 1, columnCount: numberOfPaths), frame: rect)

        
        var bezierPaths = [UIBezierPath]()
        for shapeNum in 1..<shapeGrid.cellCount  {
            var shapeRect = shapeGrid[shapeNum]!
            


            switch (symbol) {
                
                
            case .diamond:
                let topPoint = CGPoint(x: shapeRect.midX, y: shapeRect.maxY * 0.25)
                let rightPoint = CGPoint(x: shapeRect.maxX , y: shapeRect.maxY * 0.5)
                let bottomPoint = CGPoint(x: shapeRect.midX, y: shapeRect.maxY * 0.75)
                let leftPoint = CGPoint(x: shapeRect.minX, y: shapeRect.maxY * 0.5)
                
                var bezierPath = UIBezierPath()
                bezierPath.move(to: topPoint)
                bezierPath.addLine(to: topPoint)
                bezierPath.addLine(to: rightPoint)
                bezierPath.addLine(to: bottomPoint)
                bezierPath.addLine(to: leftPoint)
                bezierPath.addLine(to: topPoint)
                
                
                
                
                
                bezierPath.close()
                bezierPaths.append(bezierPath)
                
            default:
                bezierPaths.append(UIBezierPath())
            }
        }
        return bezierPaths
    }
    
    
    //uses the Grid struct to return a begin point to start drawing shape
    //returns the min starting point and the max starting point to draw in
    private func provideHorizontalDrawingRegion(for rect: CGRect, forThisShapeNumber num: Int, withTotalShapeCount count: Int) -> CGRect? {
        let shapeGrid = Grid(layout: .dimensions(rowCount: 1, columnCount: count), frame: rect)
        if let shapeStart = shapeGrid[num] {
            return shapeStart
        }
        return nil
    }
    
    
    var itemsToDisplay = 0 { didSet { setNeedsDisplay(); setNeedsLayout()}}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.cellCount = itemsToDisplay
        
    }
    
    enum Number: Int {
        case one = 1
        case two
        case three
        static let all = [one, two, three]
        
    }
    
    enum Symbol {
        case diamond
        case squiggle
        case oval
        static let all = [diamond,squiggle,oval]
    }
    
    enum Shading  {
        case solid
        case striped
        case open
        static let all = [solid, striped, open]
    }
    
    enum Color {
        case red
        case green
        case purple
        static let all = [red, green, purple]
    }
    
}

extension GridView {
    private struct Padding {
        static let gridBoundHorizontal = 0.15
        static let gridBoundsVetical = 0.15
        static let betweenSymbolHorizontal = 0.02
    }
    
    private struct SymbolPlacementRelativeToBounds {
        static let topY = 0.25
        static let topX = 0.5
        static let rightY = 0.5
        static let rightX = 0.75
        static let bottomY = 0.75
        static let bottomX = 0.5
        static let leftY = 0.5
        static let leftX = 0.25
        
    }
    
    
    
    
}

