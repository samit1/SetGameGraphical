//
//  shapeViewControllerViewController.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

class shapeViewController: UIViewController, UIGestureRecognizerDelegate {
    private var game = SetGame() 
    private var cardsOnScreen = [CardView]()
    private var cardsSelectedOnScreen : [Card] {
        get {
            return game.cardsSelected
        }
    }
    
    @IBOutlet weak var cardGrid: UIView! {didSet {
        cardGrid.setNeedsLayout(); cardGrid.setNeedsDisplay();  updateViewFromModel()
        }
    }
    
    
    @IBAction func dealMoreCardsBtnTapped(_ sender: UIButton) { add3CardsInPlay() }
    
    
    @IBOutlet weak var deal3MoreCardsBtn: UIButton!
    
    @objc func cardBtnTapped(_ recognizer : UITapGestureRecognizer) {
        guard let tapped = recognizer.view as? CardView  else {return}
        
        if let selectedCard = cardsOnScreen.index(of: tapped) {
            if let card = cardsOnScreen[selectedCard].card {
                game.cardSelected(card: card)
            }
        }
        updateViewFromModel()
    }
    
    @objc func addThreeCardsOnSwipeDown(_ recognizer : UISwipeGestureRecognizer) {
       // guard (recognizer.view as? CardView) != nil else {return}
        add3CardsInPlay()
    }
    
    @objc func shufleCardsOnRotationDetection (_ recognizer : UIRotationGestureRecognizer) {

        print("rotation detecvted")
        if recognizer.state == .ended {
            game.shuffleCards(type: .cardsOnTable)
            updateViewFromModel()
        }
        
        
    }
    
    private func add3CardsInPlay() {
        game.add3CardsToPlay()
        updateViewFromModel()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        cardGrid.contentMode = .redraw
        updateViewFromModel()
        addSwipeGestureToCardGrid()
        addRotationGestureToCardGrid()
    }
    
    override func viewDidLayoutSubviews() {
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        removeSubviewsFromCardGrid()
        createGridWithCards()
        addSelectionBordersIfNeeded()
    }
    
    private func createGridWithCards() {
        
        var grid = Grid(layout: .aspectRatio(8/5), frame: cardGrid.bounds)
        grid.cellCount = game.cardsInPlay.count
        for (index, card) in game.cardsInPlay.enumerated() {
            if let display = grid[index] {
                let cardview = CardView(frame: display, card: card)
                let tap = UITapGestureRecognizer(target: self, action: #selector(cardBtnTapped))
                tap.delegate = self
                cardview.addGestureRecognizer(tap)
                cardview.contentMode = .redraw
                
                cardGrid.addSubview(cardview)
                cardsOnScreen.append(cardview)
            }
        }
    }
    
    
    //TODO : Create Layout Strategy
//    private func determineLayoutStrategy() -> Grid.Layout {
//        if
//    }
    
    private func removeSubviewsFromCardGrid() {
        cardGrid.subviews.forEach {$0.removeFromSuperview()}
    }
    
    private func addSelectionBordersIfNeeded() {
        cardsOnScreen.forEach({
            if let card = $0.card, cardsSelectedOnScreen.contains(card)  {
                $0.selectState = .selected
            } else {
                $0.selectState = .unselected
            }
        })
    }
    
    private func addSwipeGestureToCardGrid() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCardsOnSwipeDown))
        swipe.direction = UISwipeGestureRecognizerDirection.down
        swipe.delegate = self
        cardGrid.addGestureRecognizer(swipe)
    }
    
    private func addRotationGestureToCardGrid() {
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shufleCardsOnRotationDetection))
        cardGrid.isUserInteractionEnabled = true
        rotation.delegate = self
        cardGrid.addGestureRecognizer(rotation)
    }
    
    
}

