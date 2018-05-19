//
//  ViewController.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var game = SetGame()
    
    
    @IBOutlet weak var cardGrid: GridView! {
        didSet {
            
            cardGrid.itemsToDisplay = game.cardsInPlay.count
            
        }
    }
    
    
    
    
    @IBOutlet var cardBtns: [UIButton]!
    
    @IBAction func dealMoreCardsBtnTapped(_ sender: UIButton) {
        game.add3CardsToPlay()
        updateViewFromModel()
    }
    
    
    @IBOutlet weak var deal3MoreCardsBtn: UIButton!
    @IBAction func cardBtnTapped(_ sender: UIButton) {
        
        if let selectedIndex = cardBtns.index(of: sender) {
            if selectedIndex < game.cardsInPlay.count  {
                let selectedCard = game.cardsInPlay[selectedIndex]
                game.cardSelected(card: selectedCard)
                updateViewFromModel()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        cardGrid.itemsToDisplay = game.cardsInPlay.count
    }
    
    private func setCardTitle(with card: Card ) -> NSAttributedString {
        let attributes:  [NSAttributedStringKey : Any] = [
            .strokeWidth : CardToView.shading[card.shading]!,
            .strokeColor : CardToView.color[card.color]!,
            NSAttributedStringKey.foregroundColor : CardToView.color[card.color]!.withAlphaComponent(CardToView.shading[card.shading]!)
        ]
        
        
        var symbol = CardToView.symbol[card.symbol]
        var titleReturn = symbol
        switch card.num {
        case .one:
            titleReturn = symbol!
        case .two:
            titleReturn = symbol!
            titleReturn! += symbol!
        case.three:
            titleReturn = symbol!
            titleReturn! += symbol!
            titleReturn! += symbol!
            
        }
        
        let attrTitle = NSAttributedString(string: titleReturn!, attributes: attributes)
        return attrTitle
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
fileprivate struct CardToView {
    static let symbol: [Card.Symbol : String] = [.diamond: "▲", .squiggle: "●", .oval: "■"]
    static let color: [Card.Color : UIColor] = [.red: UIColor.red, .green: UIColor.green, .purple: UIColor.purple]
    static let shading : [Card.Shading : CGFloat] = [.solid: -5, Card.Shading.open: 50, .striped: 20]
    static let number : [Card.Number : Int] = [Card.Number.one : 1, Card.Number.two : 2, Card.Number.three : 3]
    
    
}
