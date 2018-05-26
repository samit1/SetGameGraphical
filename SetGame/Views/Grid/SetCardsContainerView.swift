//
//  SetCardsContainerView.swift
//  SetGame
//
//  Created by Sami Taha on 5/26/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardsContainerView: CardsContainerGridView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        if numberOfViewsForDisplay > 0 {
            addCards(byamount: numberOfViewsForDisplay, animated: false)
            repositionViews()

            for card in cards as! [SetCardView] {
                
                card.card = SetCardView.generateRandomCard()
                card.isFlippedUp = true
//                card.backgroundColor = UIColor.white
//                card.layer.cornerRadius = 10.0
                card.setNeedsDisplay()
            }
        }
    }
    
    override func makeCardViews(byAmount numberOfCards: Int) -> [CardView] {
        return (0..<numberOfCards).map {_ in SetCardView()}
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
