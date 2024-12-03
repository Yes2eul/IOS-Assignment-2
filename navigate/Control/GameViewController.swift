//
//  GameViewController.swift
//  navigate
//
//  Created by Yeseul Shin on 3/4/2023.
//

import Foundation
import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    var name: String?
    var remainingTime = 60
    var maxNumberOfBubbles = 15
    var timer = Timer()
    var bubble = Bubble()
    var bubblesArray = [Bubble]()
    var lastBubbleValue: Double = 0
    var score: Double = 0
    var previousHighScores: Dictionary? = [String : Double]()
    var highScoreSorted = [(key: String, value: Double)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // nameLabel.text = name
        
        remainingTimeLabel.text = String(remainingTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.counting()
            self.removeBubble()
            self.generateBubble()
        }
    }
    
    func counting() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        if remainingTime == 0 {
            timer.invalidate() // stop the timer
            
            // save high score
            saveHighScore()
            
            // show HighScroe Screen
            let vc = storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
            self.navigationController?.pushViewController(vc, animated: true)
            vc.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    func isOverlapped(bubbleToCreate: Bubble) -> Bool {
        for currentBubbles in bubblesArray {
            if bubbleToCreate.frame.intersects(currentBubbles.frame) {
                return true
            }
        }
        return false
    }
    
    @objc func generateBubble() {
        let numberOfBubbles = arc4random_uniform(UInt32(maxNumberOfBubbles - bubblesArray.count)) + 1
        var i = 0
        
        while i < numberOfBubbles {
            bubble = Bubble()
            let bubbleSize: CGFloat = 50.0
            bubble.frame = CGRect(x: CGFloat.random(in: bubbleSize...(gameView.bounds.width - bubbleSize)), y: CGFloat.random(in: bubbleSize...(gameView.bounds.height - bubbleSize)),width: bubbleSize,height: bubbleSize)
            
            if !isOverlapped(bubbleToCreate: bubble) {
                bubble.addTarget(self, action: #selector(bubblePressed), for: UIControl.Event.touchUpInside)
                self.gameView.addSubview(bubble)
                bubble.animation()
                i += 1
                bubblesArray += [bubble]
            }
        }
        
        /*
         bubble = Bubble()
         bubble.animation()
         bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
         self.view.addSubview(bubble)
         */
        
    }
    
    @objc func removeBubble() {
        var i = 0
        while i < bubblesArray.count {
            if arc4random_uniform(100) < 33 {
                bubblesArray[i].removeFromSuperview()
                bubblesArray.remove(at: i)
                i += 1
            }
        }
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        sender.removeFromSuperview()
        
        // update score
        if lastBubbleValue == sender.points {
            score += sender.points * 1.5
        } else {
            score += sender.points
        }
        lastBubbleValue = sender.points
        currentScoreLabel.text = "\(score)"
        
        if let name = name {
            let newGameScore = GameScore(name: name, Score: score)
            
            // Obtain a reference to the existing HighScoreViewController
            guard let highScoreVC = self.storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController") as? HighScoreViewController else {
                return
            }
            // Update high score label to display the highest score
            if let previousHighScores = UserDefaults.standard.dictionary(forKey: "highScore") as? [String: Double] {
                self.previousHighScores = previousHighScores
                let sortedScores = previousHighScores.sorted { $0.value > $1.value }
                if let topScore = sortedScores.first {
                    if score > topScore.value {
                        highScoreLabel.text = "\(score)"
                    } else {
                        highScoreLabel.text = "\(topScore.value)"
                    }
                }
            }
            
            // Append the new game score to the existing high score array and write it back to UserDefaults
            highScoreVC.writeHighScore(newScore: newGameScore)
        }
    }
    
    func saveHighScore() {
        if var previousHighScores = UserDefaults.standard.dictionary(forKey: "highScore") as? [String: Double] {
            // Check if the name already exists in the dictionary
            if let existingScore = previousHighScores[name ?? ""] {
                // Update the existing score if the new score is higher
                if score > existingScore {
                    previousHighScores[name ?? ""] = score
                    UserDefaults.standard.set(previousHighScores, forKey: "highScore")
                }
            } else {
                // Add the new score to the dictionary
                previousHighScores.updateValue(score, forKey: name ?? "")
                UserDefaults.standard.set(previousHighScores, forKey: "highScore")
            }
        } else {
            // If the dictionary doesn't exist yet, create a new one
            let newHighScore: [String: Double] = [name ?? "": score]
            UserDefaults.standard.set(newHighScore, forKey: "highScore")
        }
    }

}
