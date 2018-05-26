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
    private (set) var deck = CardDeck().cardSet
    
    
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
    
    /// The cards that were matched.
    /// These cards are a Set
    /// - Note: A matched set contains 3 cards
    private (set) var matchedCards = [[Card]]()
    
    mutating func cardSelected(card: Card) {
        //add card in card selected
        
        // if we already have 3, check for set or not set.
        // if set, then add to matchedcards. then replace the 3 (if possible). Don't add itself twice.
        //
        
        // Before doing anything
        // check if card is already selected
        // and check if card is a playable card
        // if card is already selected by user,  remove it.
        if cardsSelected.contains(card) {
            cardsSelected.remove(at: cardsSelected.index(of: card)!)
            return
        }
        
        if !cardsInPlay.contains(card) {return}
        
        if checkForSet() {
            setFound()
            //            add3CardsToPlay()
        } else {
            // if cards are not set
            // then clear selection
            // and add new card as first element in selection
            if cardsSelected.count == 3 {
                cardsSelected.removeAll()
                cardsSelected.append(card)
            } else {
                cardsSelected.append(card)
            }
        }
    }
    
    private func checkForSet() -> Bool {
        // we can only have 3 total cards.
        // A set is matched so long as you don't have 2 of one type of card
        // So, we can pull the type in the card with the map function, and put into an array
        // If the unique count of the set is 2, that means that 3 of our cards had 2 unique values.
        // Per the rules of the game Set, if you can sort a group of three cards into two of _ and one of _ then it is not a set.
        
        if cardsSelected.count == 3 {
            //            let a  = cardsSelected.map {cardsSelected[$0.color.rawValue}
            let num = Set(cardsSelected.map {$0.num}).count
            let symbol = Set(cardsSelected.map {$0.symbol}).count
            let shading = Set(cardsSelected.map {$0.shading}).count
            let color = Set(cardsSelected.map {$0.color}).count
            
            return true //num != 2 && symbol != 2 && shading != 2 && color != 2
        }
        return false
    }
    
    // when a set is found
    // add it to the matched cards
    // removed selection
    // add 3 cards to play
    //TODO: add protection here
    mutating private func setFound() {
        //        matchedCards += cardsSelected
        for matchSetCard in cardsSelected {
            let indexOfMatch = cardsInPlay.index(of: matchSetCard)
            if deck.count > 0 {
                cardsInPlay[indexOfMatch!] = deck.remove(at: 0)
            } else {
                cardsInPlay.remove(at: indexOfMatch!)
            }
        }
        cardsSelected.removeAll()
        //        print("found set")
    }
    
    
    // TODO: If deck.count > 0, remove matched cards from screen entirely
    mutating func dealCards(forAmount amount : Int = 3) {
        guard amount > 0 else {return} // Check amount to draw is positive
        guard deck.count > 0 else {return} // Check there are cards available to take
        
        
        // either "replace cards" or add 3 more
        // to "replace cards" we check if there is a set.
        // if a set is found, then we call the setFound method
        // either way we want to add 3 cards which is done after
        
        if(checkForSet()) {
            setFound()
            
        } else {
            for _ in 0..<amount {
                cardsInPlay.append(deck.removeFirst())
            }
            
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
        deck = CardDeck().cardSet
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
