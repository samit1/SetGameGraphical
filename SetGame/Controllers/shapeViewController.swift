//
//  shapeViewControllerViewController.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit
@IBDesignable
class shapeViewController: UIViewController, UIGestureRecognizerDelegate, CardsContainerGridViewDelegate {
    var isAnimatingCardRemoval: Bool = false { didSet {
        
        }
    }
    var isAnimatingRepositioning: Bool = false {didSet {
        print(isAnimatingRepositioning)
        }
        
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
        /// At end of deck, remove matched cards
        
        if game.deck.isEmpty {
            for card in game.lastMatchedSet {
                for (index,view) in cardGrid.cards.enumerated() {
                    if let setCardView = view as? SetCardView {
                        if setCardView.card == card {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 2.5
                                , delay: 0.0
                                , options: .curveEaseOut
                                , animations: {setCardView.alpha = 0.0}
                                , completion: {[unowned self] finished in
                                    self.cardGrid.removeCard(at: index)
                                    self.cardGrid.updateViewsWithAnimation()
                                    self.updateViewFromModel()
                            })
                        }
                    }
                }
            }
        }
        

        
        
        /// Set card for each cardsOnScreen (if possible)
        for (index, cardView) in cardGrid.cards.enumerated() {
            if let setCardView = cardView as? SetCardView {
                guard game.cardsInPlay.indices.contains(index) else {continue}
                let card = game.cardsInPlay[index]
                setCardView.card = card
                setCardView.isFlippedUp = true
                
                
                /// Assigned Target Actions to each view
                assignTapAction(to: setCardView)
                
                /// Selection
                if game.cardsSelected.contains(card) {
                    setCardView.selectState = true
                } else {
                    setCardView.selectState = false
                }
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

