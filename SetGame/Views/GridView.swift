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
    var cardsToDisplay = [Card]() { didSet { setNeedsDisplay(); setNeedsLayout()}}


    override func draw(_ rect: CGRect) {
//        for (index, card) in cardsToDisplay.enumerated() {
//            print("\(index)) + \(card.description)")
//        }
        self.subviews.forEach({ $0.removeFromSuperview() })
        //self.backgroundColor = UIColor.clear
        grid.frame = self.bounds
        for (index, card) in cardsToDisplay.enumerated() {
            if let display = grid[index] {
                let card = CardView(frame: display, )
//                let tap = UITapGestureRecognizer(target: , action: Selector("handleTap:"))
//                if let shapeVC = UIViewController as? shapeViewController {
                // TODO: Add casting to shapeViewController
                if let vc = UIViewController() as? shapeViewController {
                    let tap = UIGestureRecognizer(target: vc, action: #selector(vc.cardBtnTapped))
                    tap.delegate = vc as? UIGestureRecognizerDelegate
                    self.addGestureRecognizer(tap)
                    self.isUserInteractionEnabled = true
                }

//                }
                self.addSubview(card)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid.cellCount = cardsToDisplay.count
        
    }
}



