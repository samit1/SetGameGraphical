//
//  CardRect.swift
//  SetGame
//
//  Created by Sami Taha on 5/19/18.
//  Copyright © 2018 taha.sami. All rights reserved.
//

import Foundation
import UIKit

struct cardRect {
    
    
    
    enum Number: Int {
        case one = 1
        case two
        case three
        static let all = [one, two, three]
        
    }
    
    enum Symbol {
        case diamond
        case squiggle
        case oval
        static let all = [diamond,squiggle,oval]
    }
    
    enum Shading  {
        case solid
        case striped
        case open
        static let all = [solid, striped, open]
    }
    
    enum Color {
        case red
        case green
        case purple
        static let all = [red, green, purple]
    }
    
}
