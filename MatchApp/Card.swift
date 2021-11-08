//
//  Card.swift
//  MatchApp
//
//  Created by ZHONGTAO REN on 20/8/21.
//

import Foundation

class Card {
    
    var imageName : String
    
    var isMatched : Bool
    
    var isFlipped : Bool
    
    init(cardNumber:Int) {
        imageName = "card\(cardNumber)"
        isMatched = false
        isFlipped = false
    }
    
}
