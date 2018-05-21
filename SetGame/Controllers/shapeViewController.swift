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
    
    
    @IBAction func dealMoreCardsBtnTapped(_ sender: UIButton) {
        game.add3CardsToPlay()
        updateViewFromModel()
    }
    
    
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
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        cardGrid.contentMode = .redraw
        updateViewFromModel()
    }
    
    override func viewDidLayoutSubviews() {
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        removeSubviewsFromCardGrid()
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
        addSelectionBordersIfNeeded()
    }
    
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
    
    
}
