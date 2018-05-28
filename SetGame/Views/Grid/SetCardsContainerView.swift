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
            addCards(byamount: numberOfViewsForDisplay)

            for card in cards as! [SetCardView] {
                
                card.card = SetCardView.generateRandomCard()
                card.isFlippedUp =  true 
                
            }
        }
    }
    
    override func makeCardViews(byAmount numberOfCards: Int) -> [CardView] {
        return (0..<numberOfCards).map {_ in SetCardView()}
    }
    
    /// - Parameter index: the index of CardView which you want to remove (if exists)
    /// - Parameter animated: Bool indicated if removal should be animated
    /// - Parameter completion: Optional completion to be called after an animation
    func fadeAwayCards(at index: Int, animated : Bool = false, completion : Optional<() -> ()> = nil ) {
//        guard cards.indices.contains(index) else {return}
//        guard grid.cellCount > 0 else {return}
//        let cardView = cards[index]
//        if animated {
//            UIViewPropertyAnimator.runningPropertyAnimator(
//                withDuration: 0.3,
//                delay: 0.0,
//                options: .curveEaseOut,
//                animations: {
//                    cardView.alpha = 0
//            },
//                completion: {[unowned self] finished in
//                    cardView.removeFromSuperview()
//                    //self.grid.cellCount = self.cards.count
//                    //self.cards.remove(at: index)
//                    self.updateViewsWithAnimation()
//                    if let completion = completion {
//                        completion()
//                    }
//                    if self.delegate != nil {self.delegate?.didFinishRemoving()}
//            })
//        } else {
//            //            cardView.removeFromSuperview()
//            //            cards.remove(at: index)
//            //            grid.cellCount -= 1
//        }
    }
    
    func dealACard() {
        for cardView in cards {
            if let setCardView = cardView as? SetCardView {
                if cardView.alpha < 0.1 {
                    
                    cardView.alpha = 1.0

            }
//                UIViewPropertyAnimator.runningPropertyAnimator(
//                    withDuration: 0.3,
//                    delay: 0.0,
//                    options: .curveEaseIn,
//                    animations: {cardView.alpha = 1.0 })
//                //completion: <#T##((UIViewAnimatingPosition) -> Void)?##((UIViewAnimatingPosition) -> Void)?##(UIViewAnimatingPosition) -> Void#>)
            }
        }
    }

    
}
