//
//  ViewController.swift
//  MatchApp
//
//  Created by ZHONGTAO REN on 19/8/21.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cards = [Card]()
    
    var timer: Timer?
    var milliseconds:Int = 10 * 60 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cards = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialize the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }

    // MRAK: -Timer Methods
    
    @objc func timerFired() {
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reached zero
        if milliseconds == 0 {
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // Check if the user has cleared all the pairs
            checkForGameEnd()
        }
        
    }

    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Return number of cards
        return cards.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Configure the state of the cell based on the properties of the Card that it represents
        
        let cardCell = cell as? CardCollectionViewCell
        let card  = cards[indexPath.row]
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false && milliseconds > 0 {
            // Flip the card
            cell?.flipUp()
            
            // Play sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first card that was flipped or the second card
            if firstFlippedCardIndex == nil {
                // This is the first card flipped over
                firstFlippedCardIndex = indexPath
            }
            else {
                // Second card that is flipped
                
                // Run the comparison logic
                checkForMatch(indexPath)
            }
        }
       
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the two card objectcts for the two indices and see if they match
        let cardOne = cards[firstFlippedCardIndex!.row]
        let cardTwo = cards[secondFlippedCardIndex.row]
        
        // Get the two view cells
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Compare the two
        if cardOne.imageName == cardTwo.imageName {
            // It's matched
            
            // Play sound
            soundPlayer.playSound(effect: .match)
            
            // Set the status and remove them
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Was the game end
            checkForGameEnd()
        }
        else {
            // It's not a match
            
            // Play sound
            soundPlayer.playSound(effect: .nomatch)
            
            // Flip them back over
            cardOneCell?.flipDown(speed: 0.3)
            cardTwoCell?.flipDown(speed: 0.3)
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        // Check if there's any card that is unmatched
        
        var hasWon = true
        
        for card in cards {
            if card.isMatched == false {
                hasWon = false
                break
            }
        }
        
        if hasWon {
            showAlert(title: "Congratulations!", message: "You've won the game!")
        }
        else {
            if milliseconds <= 0 {
                showAlert(title: "Time's Up", message: "Sorry, better luck next time")
            }
            
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

