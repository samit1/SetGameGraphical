//
//  shapeViewControllerViewController.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit
@IBDesignable
class shapeViewController: UIViewController, UIGestureRecognizerDelegate, CardsContainerGridViewDelegate, SetGameDelegate {
    func cardsDidMatch(cards: [Card]) {
        //        guard var cardsOnScreen = cardGrid.cards as? [SetCardView] else {return}
        //
        //        for (index,setCardView) in cardsOnScreen.enumerated() {
        //            if let card = setCardView.card, cards.contains(card) {
        //                let completion = {
        //                    self.updateViewFromModel()
        //                }
        //
        //                cardGrid.fadeAwayCards(at: index,animated: true, completion: completion )
        //                if game.deck.isEmpty {
        //                    return
        //
        //                }
        //                cardGrid.addCards()
        //            }
        
        //        }
        
        
        //        print(cardsOnScreen)
    }
    
    func didFinishRemoving() {
        //do something after we removed
    }
    
    
    // MARK: Model variables
    private var game = SetGame()
    
    // MARK: Outlets
    
    //TODO: Remove if no more cards
    // button on screen that allows user to deal 3 more cards
    @IBOutlet weak var addCardsBtn: UIButton!
    
    
    // UIView that displays grid of cards on screen
    @IBOutlet weak var cardGrid: SetCardsContainerView!
    
    
    // MARK: Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardGrid.delegate = self
        game.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if game.cardsInPlay.isEmpty, cardGrid.cards.isEmpty {
            game.dealCards(forAmount: 12)
            cardGrid.addCards(byamount: game.cardsInPlay.count, animated: false)
            updateViewFromModel()
        }
    }
    
    // MARK: Button handlers
    
    // when tapped, cards are added on screen
    @IBAction func dealMoreCardsBtnTapped(_ sender: UIButton) {
        addCards()
    }
    
    
    // MARK: Gesture Recognizers
    
    // called when one UIView inside of Grid is tapped
    // notifies model what card was tapped
    // view gets updated
    @objc func cardBtnTapped(_ recognizer : UITapGestureRecognizer) {
        guard let tapped = recognizer.view as? SetCardView  else {return}
        guard tapped.card != nil else {return}
        game.cardSelected(card: tapped.card!)
        
        /// At end of deck, remove matched cards
        //        if game.deck.isEmpty {
        //            for card in game.lastMatchedSet {
        //                for (index,view) in cardGrid.cards.enumerated() {
        //                    if let cardSetView = view as? SetCardView {
        //                        if cardSetView.card == card {
        //                            cardGrid.removeCard(at: index, animated: true)
        //                        }
        //                    }
        //                }
        //
        //            }
        //
        //        }
        updateViewFromModel()
        
    }
    
    
    // called on a swipe down gesture
    // adds cards into play
    @objc func addThreeCardsOnSwipeDown(_ recognizer : UISwipeGestureRecognizer) {
        guard (recognizer.view) != nil else {return}
        addCards()
    }
    
    
    // called on a rotation gesture
    // when rotation ends, function notifies model that the cards should be shuffled
    
    @objc func shufleCardsOnRotationDetection (_ recognizer : UIRotationGestureRecognizer) {
        if recognizer.state == .ended {
            shuffleCardsOnScreen()
            updateViewFromModel()
        }
    }
    
    // MARK: Model Interactions
    
    // ask the model to shuffle cards
    private func shuffleCardsOnScreen() {
        game.shuffleCards(type: .cardsOnTable)
    }
    
    /// Adds cards into play (called on user request)
    /// Updates the view
    private func addCards() {
        /// If there are no more card to deal out then there is no need for UI changes
        guard !game.deck.isEmpty else {return}
        
        game.dealCards(forAmount: 3)
        
        
        cardGrid.addCards(byamount: 3, animated: true)
        updateViewFromModel()
    }
    
    // MARK: UIMaintenance
    
    // Update the view based on model changes
    private func updateViewFromModel() {
        // var cardsOnScreen = cardGrid.cards.filter({$0.alpha > 0 })
        
        let matchedCards = game.lastMatchedSet
        guard let cardsOnScreen = cardGrid.cards as? [SetCardView] else {return}
        
        /// Find the card on the screen that has a match
        /// If match, we are going to flip it over. Then the new card is going to be flipped on top of it
        /// If there are still cards, we are going to add new cardViews at that index
        var animating = false
        for (index,setCardView) in cardsOnScreen.enumerated() {
            if let card = setCardView.card, matchedCards.contains(card) {
                UIView.transition(
                    with: setCardView,
                    duration: 5,
                    options: [.transitionFlipFromLeft, .curveEaseOut],
                    animations: {
                        setCardView.isFlippedUp = false
                        animating = true
                        
                },
                    completion: { finished in
                        guard self.game.cardsInPlay.indices.contains(index) else {return}
                        UIView.transition(
                            with: setCardView,
                            duration: 5,
                            options: [UIViewAnimationOptions.transitionFlipFromTop, UIViewAnimationOptions.curveEaseIn],
                            animations: {
                                setCardView.isFlippedUp = true
                                self.setCardViews()
                                setCardView.card = self.game.cardsInPlay[index]
                                
                        })
                        
                })
                
            }
        }
        if !animating {
            setCardViews()
        }
        
        
    }
    
    private func setCardViews() {
        /// Set card for each cardsOnScreen (if possible)
        for (index, cardView) in cardGrid.cards.enumerated() {
            if let setCardView = cardView as? SetCardView {
                guard game.cardsInPlay.indices.contains(index) else {continue}
                let card = game.cardsInPlay[index]
                setCardView.card = card
//                if !setCardView.isFlippedUp {
//                    UIView.transition(
//                        with: setCardView,
//                        duration: 0.5,
//                        options: .transitionFlipFromRight,
//                        animations: {setCardView.isFlippedUp = true})
//                }
                
                
                /// Assigned Target Actions to each view
                assignTapAction(to: setCardView)
                
                /// Selection
                if game.cardsSelected.contains(card) {
                    setCardView.selectState = true
                } else {
                    setCardView.selectState = false
                }
                
                setCardView.isFlippedUp = true
                
                
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.6,
                    delay: 0,
                    options: .curveEaseInOut,
                    animations: {
                        self.cardGrid.repositionViews()
                })
                
            }
        }
    }
    
    
    private func assignTapAction(to cardView: CardView ) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardBtnTapped))
        tap.delegate = self
        cardView.addGestureRecognizer(tap)
    }
    
    /*
     let tap = UITapGestureRecognizer(target: self, action: #selector(cardBtnTapped))
     tap.delegate = self
     cardview.addGestureRecognizer(tap)
     cardview.contentMode = .redraw
     
     */
    
    
    
    // draw grids on screen
    //    private func createGridWithCards() {
    //        cardGrid.cards.removeAll()
    //        for card in game.cardsInPlay {
    //            if cardGrid.cards.isEmpty {
    //                cardGrid.addCards(byamount: 12, animated: false)
    //            }
    //        }
    //    }
    
}

// MARK: Add gestures

// add swipe gestures
//    private func addSwipeGestureToCardGrid() {
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCardsOnSwipeDown))
//        swipe.direction = UISwipeGestureRecognizerDirection.down
//        swipe.delegate = self
//        cardGrid.addGestureRecognizer(swipe)
//    }

// add rotation gestures
//    private func addRotationGestureToCardGrid() {
//        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shufleCardsOnRotationDetection))
//        cardGrid.isUserInteractionEnabled = true
//        rotation.delegate = self
//        cardGrid.addGestureRecognizer(rotation)
//    }
//}

