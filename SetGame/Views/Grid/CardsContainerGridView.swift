//
//  CardsContainerGridView.swift
//  SetGame
//
//  Created by Sami Taha on 5/25/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

protocol CardsContainerGridViewDelegate {
    func didFinishRemoving()
}

@IBDesignable
class CardsContainerGridView: UIView  {

    
    /// The number of items to display in storyboard
    @IBInspectable var numberOfViewsForDisplay: Int = 0
    
    var delegate: CardsContainerGridViewDelegate?
    
    /// The cards that need to be arranged in a grid
    var cards = [CardView]() //{ didSet {updateViewsWithAnimation()}}
    
    
    /// The grid that is in charge of
    /// calculating the frame for each card
    var grid = Grid(layout: .aspectRatio(3/2))
    
    
    /// The frame of the desired grid
    var gridFrame : CGRect { 
        let rect = CGRect(x: self.bounds.width * 0.05,
                          y: self.bounds.height * 0.05 ,
                          width: self.bounds.width * 0.90,
                          height: self.bounds.height * 0.90)
        return rect
    }
    
    var positioningAnimator: UIViewPropertyAnimator?
    var cardsToPosition : [CardView] {
        return cards
    }
    
    //MARK: Imperatives
    
    /// Makes a new array of cards
    func makeCardViews (byAmount numberOfCards: Int) -> [CardView] { return []}
    
    
    /// Adds new cards to the UI
    /// - Parameter amount: The number of cards to be added
    func addCards(byamount amount: Int = 3) {
        let cardsViews = makeCardViews(byAmount: amount)
        
        for card in cardsViews {
            addSubview(card)
            cards.append(card)
        }
        grid.cellCount += amount
        grid.frame = gridFrame
    }
    
    
    /// Called whenever cards should be repositioned.
    func repositionViews() {
        grid.frame = gridFrame
        grid.cellCount = cards.count
        
        for (index,card) in cards.enumerated() {
            guard let frame = grid[index] else {return}
            card.frame = frame
        }
        setNeedsLayout()
        setNeedsDisplay()
        
    }
 
    
}



extension UIView {
    func removeAllSubviews() {
        self.subviews.forEach ({
            $0.removeFromSuperview()
        })
    }
}

