//
//  CardView.swift
//  SetGame
//
//  Created by Sami Taha on 5/20/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit
// Generic Card functionality
@IBDesignable
class CardView: UIView {
    
    /// The CardView default to selected
    @IBInspectable var selectState : Bool = true {
        didSet {
            if selectState {
                layer.borderColor = SelectionStyling.selected.borderColor
                layer.borderWidth = SelectionStyling.selected.borderWidth
            } else {
                layer.borderColor = SelectionStyling.unselected.borderColor
                layer.borderWidth = SelectionStyling.unselected.borderWidth
            }
            setNeedsDisplay()
        }
    }
    
    /// The CardView can be flipped up or not flipped up
    @IBInspectable var isFlippedUp: Bool = true {
        didSet {
            if isFlippedUp {
                backgroundColor = BackgroundColors.frontsideColor
            } else {
                backgroundColor = BackgroundColors.backsideColor
            }
            setNeedsDisplay()
        }
    }
    
    // MARK: Drawing
    
    override func draw(_ rect: CGRect) {
        
        layer.cornerRadius = 12.0
        
        if isFlippedUp {
            drawFront()

        } else {
            drawBack()
            print("back drawn")
        }
    }
    
    /// Draws the front of the card
    func drawFront() {}
    
    /// Draws the back of the card
    func drawBack() {}
    
    
}

private struct BackgroundColors {
    static var backsideColor = UIColor.orange
    static var frontsideColor = UIColor.white
}

private struct SelectionStyling {
     struct selected {
        static var borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor
        static var borderWidth = CGFloat(2.0)
    }
    struct unselected {
        static var borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).cgColor
        static var borderWidth = CGFloat(0.4)
    }
}

