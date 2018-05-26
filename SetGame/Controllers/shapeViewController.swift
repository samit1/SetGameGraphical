//
//  shapeViewControllerViewController.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit
@IBDesignable
class shapeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Model variables
    private var game = SetGame()
    
    // MARK: Outlets
    
    // button on screen that allows user to deal 3 more cards
    @IBOutlet weak var deal3MoreCardsBtn: UIButton!
    
    // UIView that displays grid of cards on screen
    @IBOutlet weak var cardGrid: SetCardsContainerView!
    
    // MARK: Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if game.cardsInPlay.isEmpty, cardGrid.cards.isEmpty {
            game.dealCards(forAmount: 12)
            updateViewFromModel()
        }
    }
    
    // MARK: Button handlers
    
    // when tapped, cards are added on screen
    @IBAction func dealMoreCardsBtnTapped(_ sender: UIButton) { add3CardsInPlay()
//        for card in game.cardsInPlay[0...3] {
//            cardGrid.addCards()
//        }
    }
    
    
    // MARK: Gesture Recognizers
    
    // called when one UIView inside of Grid is tapped
    // notifies model what card was tapped
    // view gets updated
    @objc func cardBtnTapped(_ recognizer : UITapGestureRecognizer) {
//        guard let tapped = recognizer.view as? SetCardView  else {return}
//
//        if let selectedCard = game.cardsInPlay.index(of: tapped) {
//            if let card = game.cardsInPlay[selectedCard].card {
//                game.cardSelected(card: card)
//            }
//        }
//        updateViewFromModel()
    }
    
    
    // called on a swipe down gesture
    // adds cards into play
    @objc func addThreeCardsOnSwipeDown(_ recognizer : UISwipeGestureRecognizer) {
        guard (recognizer.view) != nil else {return}
        add3CardsInPlay()
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
    
    // adds cards into play (called on user request)
    // updates the view
    private func add3CardsInPlay() {
        //game.dealCards()
        updateViewFromModel()
    }
    
    // MARK: UIMaintenance
    
    // update the view based on model changes
    private func updateViewFromModel() {
        
        /// Update card.makeCardViews so it knows how many cards to display
       cardGrid.addCards(byamount: game.cardsInPlay.count, animated: false)
       // cardGrid.frame = cardGrid.bounds
        
        /// Set card for each cardsOnScreen (if possible)
        for (index, cardView) in cardGrid.cards.enumerated() {
            if let setCardView = cardView as? SetCardView {
                guard game.cardsInPlay.indices.contains(index) else {return}
                
                let card = game.cardsInPlay[index]
                setCardView.card = card

            }
        }
        
        
        
        
        
        
    }
    
    
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

