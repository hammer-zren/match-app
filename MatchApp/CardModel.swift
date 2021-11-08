//
//  CardModel.swift
//  MatchApp
//
//  Created by ZHONGTAO REN on 20/8/21.
//

import Foundation


class CardModel {
    func getCards() -> [Card] {
        // Declare an empty array
        var generatedCards = [Card]()
        
        // Randomly generate 8 pairs of cards
        var distinctRandamNumbers = [Int]()
        while generatedCards.count < 16 {
            
            // Generate a random number
            let randomNumber = Int.random(in: 2...14)
            if !distinctRandamNumbers.contains(randomNumber) {
                
                distinctRandamNumbers.append(randomNumber)
                
                // Add a pair of cards into the array
                generatedCards += [Card(cardNumber: randomNumber), Card(cardNumber: randomNumber)]
                
//                print("random: \(randomNumber) generated \(generatedCards.count) cards")
            }
        }
        
        // Randomize the cards within the array
        generatedCards.shuffle()
        for card in generatedCards {
            print(card.imageName)
        }
        
        // Return the array
        return generatedCards
    }
}
