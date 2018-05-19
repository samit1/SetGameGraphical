//
//  CardSet.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import Foundation

struct CardDeck {
    /*
     The deck consists of 81 cards varying in four features:
     -- number (one, two, or three);
     -- symbol (diamond, squiggle, oval);
     -- shading (solid, striped, or open);
     -- and color (red, green, or purple).
    
     Each possible combination of features (e.g., a card with three striped green diamonds)
     appears precisely once in the deck.
    */
    private (set) var cardSet = [Card]()

//
    init() {
        for num in Card.Number.all {
            for symbol in Card.Symbol.all {
                for shading in Card.Shading.all {
                    for color in Card.Color.all {
                        cardSet.append(Card(num: num, symbol: symbol, shading: shading, color: color))
                    }
                }
            }
        }
    }
}
