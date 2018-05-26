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

            for card in cards as! [SetCardView] {
                
                card.card = SetCardView.generateRandomCard()
                card.isFlippedUp =  true 
                
            }
        }
    }
    
    override func makeCardViews(byAmount numberOfCards: Int) -> [CardView] {
        return (0..<numberOfCards).map {_ in SetCardView()}
    }

    
}
