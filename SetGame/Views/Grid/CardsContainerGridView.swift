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
    var cards = [CardView]() {
        didSet {
            updateViewsWithAnimation()
            repositionViews()
            
//            for card in cards {
////                print(card.frame)
//            }
        }
    }

    
    /// The grid that is in charge of
    /// calculating the frame for each card
    var grid = Grid(layout: .aspectRatio(3/2))
    
    
    /// The frame of the desired grid
    var gridFrame : CGRect {
//        let rect = CGRect(x: self.bounds.width * 0.05,
//                          y: self.bounds.height * 0.10 ,
//                          width: self.bounds.width * 0.95,
//                          height: self.bounds.height * 0.90)
        return self.bounds
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
    /// - Parameter animated: Bool indicating if the addition should be animated
    func addCards(byamount amount: Int = 3, animated : Bool = false) {
        let cardsViews = makeCardViews(byAmount: amount)
        
        for card in cardsViews {
            addSubview(card)
            cards.append(card)
//            print(self.frame)

        }
        grid.cellCount += amount
        grid.frame = gridFrame
    }
    
    
    /// - Parameter index: the index of CardView which you want to remove (if exists)
    /// - Parameter animated: Bool indicated if removal should be animated
    func removeCard(at index: Int, animated : Bool = false) {
        guard cards.indices.contains(index) else {return}
        guard grid.cellCount > 0 else {return}
        var cardView = cards.remove(at: index)
        cardView.removeFromSuperview()
        grid.cellCount -= 1
        
    }
    
    /// Called whenever cards should be repositioned.
    /// It removes all of the existing subviews and
    /// recalculates where cards should be added back in
    func repositionViews() {
        grid.frame = gridFrame
        grid.cellCount = cards.count
        
        for (index,card) in cards.enumerated() {
            guard let frame = grid[index] else {return}
            card.frame = frame
        }
        setNeedsLayout()
        
    }

    func updateViewsWithAnimation() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.repositionViews()
                }).startAnimation()
            //completion: <#T##((UIViewAnimatingPosition) -> Void)?##((UIViewAnimatingPosition) -> Void)?##(UIViewAnimatingPosition) -> Void#>)
    }

}

extension UIView {
    func removeAllSubviews() {
        self.subviews.forEach ({
            $0.removeFromSuperview()
        })
    }
}

