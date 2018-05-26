//
//  SetGame.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import Foundation

struct SetGame {
    enum shuffleType {
        case allCards
        case cardsOnTable
    }
    
    
    /// The deck of cards
    private (set) var deck = CardDeck.generateDeckOfCards()
    
    
    /// The cards that are currently in play
    /// i.e., card is not on the table
    private (set) var cardsInPlay = [Card]() {
        didSet {
            for (i,card) in cardsInPlay.enumerated() {
                print("\(i): \(card.description) ")
            }
        }
    }
    
    /// The selected cards are used to determine whether
    /// a set of cards is a Set
    private (set) var cardsSelected = [Card]() {
        didSet {
            for (i,card) in cardsSelected.enumerated() {
                print("\(i): \(card.description) ")
            }
        }
    }
    
    /// The deck of cards that were matched.
    /// These cards are a Set
    /// - Note: A matched set contains 3 cards
    private (set) var matchedCardsDeck = [[Card]]()
    
    /// The last matched set
    /// Used as a convenience for a Controller
    /// This variable is in charge of appending its results to the matchedCardsDeck
    private (set) var lastMatchedSet = [Card]() {
        didSet {
            if lastMatchedSet.count == 3 {
                matchedCardsDeck.append(lastMatchedSet)
            }
        }
    }
    
    
    
    /// Reads in a card selected by a userz
    /// The following steps are performed:
    ///        * The card has membership in cardsInPlay (i.e., the card is a card on the table).
    ///        * Determines whether a card should be selected/unselected.
    ///        * Checks if there are 3 cards in the selection. Appropriates them to matchedCards if needed.
    /// - Note: Cards are only checked if they are a set after there are already
    /// 3 cards in the selection.
    mutating func cardSelected(card: Card) {
        guard cardsInPlay.contains(card) else {return} /// validate card is on the table
        
        /// Remove all elements if there are 3
        /// Prevents user from deselecting the third card and just adding another one (cheating)
        guard cardsSelected.count != 3 else {
            cardsSelected.removeAll()
            return
        }
        
        /// Handle whether there should be an unselection
        if cardsSelected.contains(card), let indexOfSelection = cardsSelected.index(of: card) {
            cardsSelected.remove(at: indexOfSelection)
            return
        }
        
        /// Add card to selection
        cardsSelected.append(card)
        
        /// If there are 3 cards, check for a set
        /// If true: then
        ///     * Update lastMatchedSet to include the most recent match
        ///     * Clear selected cards
        ///     * Draw new cards for matched cards
        if cardsSelected.count == 3, checkForSet(cards: cardsSelected) {
            lastMatchedSet = cardsSelected
            cardsSelected.removeAll()
            dealCards()
        }
    }
    
    /// Method in charge of determining whether an array of cards is a Set
    /// A set means if you have 2 of something and 1 of something else, then it is not a Set
    private func checkForSet(cards: [Card]) -> Bool {
        let num = Set(cardsSelected.map {$0.num}).count
        let symbol = Set(cardsSelected.map {$0.symbol}).count
        let shading = Set(cardsSelected.map {$0.shading}).count
        let color = Set(cardsSelected.map {$0.color}).count
        
        return true //num != 2 && symbol != 2 && shading != 2 && color != 2
        //    return false
    }
    
    // TODO: If deck.count > 0, remove matched cards from screen entirely
    mutating func dealCards(forAmount amount : Int = 3) {
        guard amount > 0 else {return} // Check amount to draw is positive
        guard deck.count >= amount else {return} // Check there are cards available to take
        
        
        var cardsToDeal = [Card]()
        
        for _ in 0..<amount {
            cardsToDeal.append(deck.removeFirst())
        }
        
        
        /// Replace any matched cards
        for (index,card) in cardsInPlay.enumerated() {
            if lastMatchedSet.contains(card) {
                guard cardsToDeal.count > 0 else {return}
                cardsInPlay[index] = cardsToDeal.removeFirst()
            }
        }
        
        if !cardsToDeal.isEmpty {
            cardsInPlay.append(contentsOf: cardsToDeal)
        }
        
        
    }
    
    init() {
        startNewGame()
        for x in deck {
            print(x.description)
        }
    }
    
    mutating private func showFirst12Cards() {
        for _ in stride(from: 0, to: 12, by:  1) {
            cardsInPlay.append(deck.removeFirst())
        }
    }
    
    mutating public func startNewGame() {
        deck.removeAll()
        cardsInPlay.removeAll()
        cardsSelected.removeAll()
        deck = CardDeck.generateDeckOfCards()
        shuffleCards(type: .allCards)
        showFirst12Cards()
    }
    
    mutating func shuffleCards(type : shuffleType) {
        switch type {
        case .allCards:
            deck = deck.shuffleCards()
        case .cardsOnTable:
            cardsInPlay = cardsInPlay.shuffleCards()
        }
    }
}


// TODO : Add an extension for arc4random
fileprivate extension Array where Element == Card {
    func shuffleCards() -> [Card] {
        var shuffledCards = self
        for cardIndex in stride(from: shuffledCards.count - 1 , to: -1, by: -1) {
            //let randomIndexToSwapWith = Int(arc4random_uniform(UInt32(shuffledCards.count - 1)))
            let randomIndexToSwapWith = shuffledCards.count.randIndex
            let tmp = shuffledCards[randomIndexToSwapWith] //this is the random one we swap with
            shuffledCards[randomIndexToSwapWith] = shuffledCards[cardIndex]
            shuffledCards[cardIndex] = tmp
        }
        return shuffledCards
    }
}

extension Int {
    var randIndex : Int {
        let maxIndex = self 
        if maxIndex < 0 {
            //            print(-Int(arc4random_uniform(UInt32(maxIndex))))
            return -Int(arc4random_uniform(UInt32(maxIndex)))
            
        } else if maxIndex > 0 {
            //            print(Int(arc4random_uniform(UInt32(maxIndex))))
            return Int(arc4random_uniform(UInt32(maxIndex)))
        } else {
            return 0
        }
    }
}
