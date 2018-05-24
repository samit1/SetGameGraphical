//
//  SingleShapeView.swift
//  SetGame
//
//  Created by Sami Taha on 5/20/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

class SingleShapeView: UIView {
    
    private var shape : Card.Symbol?
    private var color : Card.Color?
    private var shading : Card.Shading?
    
    init(frame: CGRect, shape: Card.Symbol, color: Card.Color, shading: Card.Shading) {
        self.shape = shape
        self.color = color
        self.shading = shading
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 0 
        self.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var path : UIBezierPath {
        if let shape = shape {
            switch (shape) {
            case .diamond:
                
                let topPoint = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
                let rightPoint = CGPoint(x: self.bounds.maxX , y: self.bounds.midY)
                let bottomPoint = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
                let leftPoint = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
                
                let bezierPath = UIBezierPath()
                bezierPath.move(to: topPoint)
                bezierPath.addLine(to: topPoint)
                bezierPath.addLine(to: rightPoint)
                bezierPath.addLine(to: bottomPoint)
                bezierPath.addLine(to: leftPoint)
                bezierPath.addLine(to: topPoint)
                bezierPath.close()
                return bezierPath
            case .oval:
                let bezierPath = UIBezierPath(ovalIn: self.bounds)
                return bezierPath
            case .square:
                let bezierPath  = UIBezierPath(rect: self.bounds)
                return bezierPath
            }
        }
        return UIBezierPath()
    }
    
    
    override func draw(_ rect: CGRect) {
        let shape = path
        shape.addClip()
        var shapeColor = UIColor.clear
        if let color = self.color {
            switch color {
            case .green : shapeColor = UIColor.green
            case .purple : shapeColor = UIColor.purple
            case .red : shapeColor = UIColor.red
            }
        }
        
        if let shading = shading {
            switch shading {
            case .open :
                shapeColor.setStroke()
                shape.stroke()
            case .solid :
                shapeColor.setFill()
                shape.fill()
            case .striped :
                shapeColor.setStroke()
                for x in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: x))
                    path.stroke()
                }
                for y in stride(from: 0, to: bounds.width, by: bounds.width / 10) {
                    let path = UIBezierPath()
                    path.move(to: CGPoint(x: y, y: bounds.height))
                    path.addLine(to: CGPoint(x: bounds.width, y: y))
                    path.stroke()
                }
            }
            
        }
    }
}
