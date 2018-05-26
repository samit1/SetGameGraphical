//
//  CardsContainerGridView.swift
//  SetGame
//
//  Created by Sami Taha on 5/25/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

@IBDesignable
class CardsContainerGridView: UIView {

    
    /// The number of items to display in storyboard
    @IBInspectable var numberOfViewsForDisplay: Int = 0
    
    
    /// The cards that need to be arranged in a grid
    var cards = [CardView]()
    
    
    /// The grid that is in charge of
    /// calculating the frame for each card
    var grid = Grid(layout: .aspectRatio(3/2))
    
    
    /// The frame of the desired grid
    var gridFrame : CGRect {
        return self.frame // can add spacing here, if desiered
    }
    
    
    /// Called whenever cards should be repositioned.
    /// It removes all of the existing subviews and
    /// recalculates where cards should be added back in
    func respositionViews() {
        self.removeAllSubviews()
        
        grid.frame = gridFrame
        grid.cellCount = cards.count
        
        for (index,card) in cards.enumerated() {
            guard let frame = grid[index] else {return}
            card.frame = frame
            self.addSubview(card)
        }
        
    }
}

extension UIView {
    func removeAllSubviews() {
        self.subviews.forEach ({
            $0.removeFromSuperview()
        })
    }
}
/*
 
 override func prepareForInterfaceBuilder() {
 super.prepareForInterfaceBuilder()
 let deck = CardDeck().cardSet
 for (i,card) in deck.enumerated() {
 let setCardView = SetCardView(card: card)
 if let frame = grid[i] {
 setCardView.frame = frame
 cards.append(setCardView)
 }
 }
 
 print("HI")
 for i in 0...numberOfViewsForDisplay {
 if cards.count > numberOfViewsForDisplay {
 self.addSubview(cards[i])
 }
 }
 }
 */
