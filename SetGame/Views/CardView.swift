//
//  CardView.swift
//  SetGame
//
//  Created by Sami Taha on 5/20/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    // The CardView default to selected
    @IBInspectable var selectState : Bool = true {
        didSet {
            if selectState {
                layer.borderColor = SelectionFrameColors.selected
            } else {
                layer.borderColor = SelectionFrameColors.unselected
            }
            setNeedsDisplay()
        }
    }
    
    // The CardView can be flipped up or not flipped up
    @IBInspectable var isFlippedUp: Bool = true {
        didSet {
            if isFlippedUp {
                layer.backgroundColor = BackgroundColors.frontsideColor
            } else {
                layer.backgroundColor = BackgroundColors.backsideColor
            }
            setNeedsDisplay()
        }
    }
    
    // MARK: Drawing
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 3.0
        layer.borderColor = SelectionFrameColors.unselected
        
        if isFlippedUp {
            drawFront()
        } else {
            drawBack()
        }
        
        
        
    }
    
    // Draws the front of the card
    func drawFront() {}
    
    // Draws the back of the card
    func drawBack() {}
    
}

fileprivate struct BackgroundColors {
    static var backsideColor = UIColor.orange.cgColor
    static var frontsideColor = UIColor.white.cgColor
}

fileprivate struct SelectionFrameColors {
    static var selected = UIColor.red.cgColor
    static var unselected = UIColor.blue.cgColor
}
