//
//  Card.swift
//  SetGame
//
//  Created by Sami Taha on 5/11/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import Foundation

public struct Card : CustomStringConvertible {
    
    /*properties are left public for easier comparison*/
    
    let num : Number
    let symbol : Symbol
    let shading : Shading
    let color : Color
    var identifier = 99999999999
    public var description: String { return "num = \(num), symbol = \(symbol), shading = \(shading), color = \(color)"  }
    /* a unique identifier is constructed from the num, symbol, shading, and color properties*/
//    private let identifier: Int
    
    init(num : Number , symbol : Symbol, shading : Shading, color : Color) {
        self.num = num
        self.symbol = symbol
        self.shading = shading
        self.color = color
        
        identifier = Int("\(num.hashValue)\(symbol.hashValue)\(shading.hashValue)\(color.hashValue)")!
        
    }
    
    /*
     The deck consists of 81 cards varying in four features:
     -- number (one, two, or three);
     -- symbol (diamond, squiggle, oval);
     -- shading (solid, striped, or open);
     -- and color (red, green, or purple).
     
     Each possible combination of features (e.g., a card with three striped green diamonds)
     appears precisely once in the deck.
     */
    enum Number: Int, CustomStringConvertible {
        case one = 1
        case two
        case three
        var description: String {return String(rawValue)}
        static let all = [one, two, three]
        
    }
    
    enum Symbol: String, CustomStringConvertible {
        case diamond = "diamond"
        case square = "squiggle"
        case oval = "oval"
        var description: String {return String(rawValue)}
        static let all = [diamond,square,oval]
    }
    
    enum Shading : String, CustomStringConvertible {
        case solid = "solid"
        case striped = "striped"
        case open = "open"
        var description: String {return String(rawValue)}
        static let all = [solid, striped, open]
    }
    
    enum Color : String, CustomStringConvertible {
        case red = "red"
        case green = "green"
        case purple = "purple"
        var description: String {return String(rawValue)}
        static let all = [red, green, purple]
    }
    
    
    
}
extension Card : Equatable {
    // MARK: Equatable and Hashable implementations
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.num == rhs.num &&
            lhs.symbol == rhs.symbol &&
            lhs.shading == rhs.shading &&
            lhs.color == rhs.color
    }
}

extension Card : Hashable {
    public var hashValue : Int {
        
        return Int(identifier)
    }
}

//number (one, two, or three); symbol (diamond, squiggle, oval); shading (solid, striped, or open); and color (red, green, or purple).[1] Each possible combination of features (e.g., a card with three striped green diamonds) appears precisely once in the deck.
