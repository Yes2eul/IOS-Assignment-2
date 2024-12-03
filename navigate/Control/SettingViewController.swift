//
//  SettingViewController.swift
//  navigate
//
//  Created by Yeseul Shin on 3/4/2023.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    
    var timerSliderValue = 60
    var bubbleSliderValue = 15
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var bubbleNoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameViewController
            VC.name = nameTextField.text! // name is optional ? so need to !
            VC.remainingTime = timerSliderValue
            VC.maxNumberOfBubbles = bubbleSliderValue
        }
    }
    
    @IBAction func timerSlider(_ sender: UISlider) {
        timerSliderValue = Int(sender.value)
        gameTimeLabel.text = "\(timerSliderValue)"
    }
    
    @IBAction func bubbleSlider(_ sender: UISlider) {
        bubbleSliderValue = Int(sender.value)
        bubbleNoLabel.text = "\(bubbleSliderValue)"
    }
    
}
