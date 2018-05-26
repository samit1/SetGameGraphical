//
//  shapeViewControllerViewController.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

class shapeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Model variables
    private var game = SetGame() 
    private var cardsOnScreen = [SetCardView]()
    private var cardsSelectedOnScreen : [Card] {get {return game.cardsSelected}}
    
    
    
    // MARK: Outlets
    
    // button on screen that allows user to deal 3 more cards
    @IBOutlet weak var deal3MoreCardsBtn: UIButton!
    
    
    // UIView that displays grid of cards on screen
    @IBOutlet weak var cardGrid: UIView! {didSet {
        cardGrid.backgroundColor = UIColor.white
        cardGrid.setNeedsLayout(); cardGrid.setNeedsDisplay();  updateViewFromModel()
        }
    }
    
    // MARK: Application Lifecycle
    
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
    
    // MARK: Button handlers
    
    // when tapped, cards are added on screen
    @IBAction func dealMoreCardsBtnTapped(_ sender: UIButton) { add3CardsInPlay() }
    
    
    // MARK: Gesture Recognizers
    
    // called when one UIView inside of Grid is tapped
    // notifies model what card was tapped
    // view gets updated
    @objc func cardBtnTapped(_ recognizer : UITapGestureRecognizer) {
        guard let tapped = recognizer.view as? SetCardView  else {return}
        
        if let selectedCard = cardsOnScreen.index(of: tapped) {
            if let card = cardsOnScreen[selectedCard].card {
                game.cardSelected(card: card)
            }
        }
        updateViewFromModel()
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
        game.add3CardsToPlay()
        updateViewFromModel()
    }
    
    // MARK: UIMaintenance
    
    // update the view based on model changes
    private func updateViewFromModel() {
        removeSubviewsFromCardGrid()
        createGridWithCards()
        addSelectionBordersIfNeeded()
    }
    
    
    // draw grids on screen
    private func createGridWithCards() {
        //var grid = Grid(layout: .dimensions(rowCount: game.cardsInPlay.count / 3 , columnCount: 4), frame: cardGrid.bounds)
        var grid = Grid(layout: .aspectRatio(8/5), frame: cardGrid.bounds)
        //var grid = Grid(layout: .aspectRatio(8/5), frame: cardGrid.bounds)
        grid.cellCount = game.cardsInPlay.count
        for (index, card) in game.cardsInPlay.enumerated() {
            if let display = grid[index] {
                let cardview = SetCardView(frame: display, card: card)
                let tap = UITapGestureRecognizer(target: self, action: #selector(cardBtnTapped))
                tap.delegate = self
                cardview.addGestureRecognizer(tap)
                cardview.contentMode = .redraw
                cardGrid.addSubview(cardview)
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.6,
                    delay: 0.0,
                    options: .curveEaseIn,
                    animations: {
                        self.cardsOnScreen.append(cardview)
                        }
                    //completion: <#T##((UIViewAnimatingPosition) -> Void)?##((UIViewAnimatingPosition) -> Void)?##(UIViewAnimatingPosition) -> Void#>)
                
            )
        }
        
    }
    }
    
    
    private func flyIn() {
        for (index,cardView) in cardsOnScreen.enumerated() {
            let cardViewCoordinates = CGPoint(x: cardView.frame.minX, y: cardView.frame.minY) // this gives us the upper left most point of the cardView
            
            cardView.center = {
                let x  = cardGrid.frame.minX + cardView.frame.width / 2
                let y = cardGrid.frame.maxY - cardView.frame.height
                return CGPoint(x: x, y: y)
            }()
            
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 0.6,
                delay: Double(index) / 80,
                options: [.curveEaseIn],
                animations:  {[unowned cardView, cardViewCoordinates] in
                    cardView.frame = CGRect(origin: cardViewCoordinates, size: cardView.frame.size)
            })
            
        }
    }
    
    // remove all subviews from grid
    private func removeSubviewsFromCardGrid() {
        cardGrid.subviews.forEach {$0.removeFromSuperview()}
    }
    
    // adds borders around UIViews if needed
    private func addSelectionBordersIfNeeded() {
        cardsOnScreen.forEach({
            if let card = $0.card, cardsSelectedOnScreen.contains(card)  {
                $0.selectState = true
            } else {
                $0.selectState = false
            }
        })
    }
    
    // MARK: Add gestures
    
    // add swipe gestures
    private func addSwipeGestureToCardGrid() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(addThreeCardsOnSwipeDown))
        swipe.direction = UISwipeGestureRecognizerDirection.down
        swipe.delegate = self
        cardGrid.addGestureRecognizer(swipe)
    }
    
    // add rotation gestures
    private func addRotationGestureToCardGrid() {
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shufleCardsOnRotationDetection))
        cardGrid.isUserInteractionEnabled = true
        rotation.delegate = self
        cardGrid.addGestureRecognizer(rotation)
    }
}

