//
//  HighScoreViewController.swift
//  navigate
//
//  Created by Yeseul Shin on 3/4/2023.
//

import Foundation
import UIKit

struct GameScore: Codable {
    var name: String
    var Score: Double
}

let KEY_HIGH_SCORE = "highSocre"

class HighScoreViewController: UIViewController {
    
    var highScore: [GameScore] = []
    var playerName: String?
    var playerScore: Double = 0.0
    
    @IBOutlet weak var tabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Read the current high scores from UserDefaults
        self.highScore = readHighScore()
        
        // Add the new game score to the array
        if let name = playerName {
            let newGameScore = GameScore(name: name, Score: playerScore)
            highScore.append(newGameScore)
            
            // Write the updated high scores back to UserDefaults
            writeHighScore(newScore: newGameScore)
        }
        
        // Sort high scores in descending order
        highScore.sort { $0.Score > $1.Score }
        
        // Keep only the top 5 scores
        highScore = Array(highScore.prefix(5))
    }

    func writeHighScore(newScore: GameScore) {
        let defaults = UserDefaults.standard
        
        var updatedHighScoreFromGame = [GameScore]()
        if let highScoreData = defaults.object(forKey: KEY_HIGH_SCORE) as? Data,
           let highScoreArray = try? PropertyListDecoder().decode([GameScore].self, from: highScoreData) {
            updatedHighScoreFromGame = highScoreArray
        }
        
        var playerIndex: Int?
        for (index, score) in updatedHighScoreFromGame.enumerated() {
            if score.name == newScore.name {
                playerIndex = index
                break
            }
        }
        
        if let index = playerIndex {
            // Update the existing score if the new score is higher
            if newScore.Score > updatedHighScoreFromGame[index].Score {
                updatedHighScoreFromGame[index].Score = newScore.Score
            }
        } else {
            updatedHighScoreFromGame.append(newScore)
        }
        
        // Sort the high score in descending order
        updatedHighScoreFromGame.sort { $0.Score > $1.Score }
        // Keep only the top 5 scores
        updatedHighScoreFromGame = Array(updatedHighScoreFromGame.prefix(5))
        
        defaults.set(try? PropertyListEncoder().encode(updatedHighScoreFromGame), forKey: KEY_HIGH_SCORE)
    }

    
    func readHighScore() -> [GameScore]{
        let defaults = UserDefaults.standard
        if let savedArrayData = defaults.value(forKey: KEY_HIGH_SCORE) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: savedArrayData){
                return array
            } else {
                return []
            }
        } else {
            return []
        }
        
    }
    
    @IBAction func returnToMain(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension HighScoreViewController:UITableViewDelegate {
    func  tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // let index = indexPath.row
        // let name = self.highScore[index]
    }

    
}

extension HighScoreViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScore.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let score = highScore[indexPath.row]
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "\(score.Score)"
        return cell
    }
}

