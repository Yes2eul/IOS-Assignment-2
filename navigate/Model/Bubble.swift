//
//  Bubble.swift
//  navigate
//
//  Created by Yeseul Shin on 3/4/2023.
//

import Foundation
import UIKit

class Bubble: UIButton {
    
    var points: Double = 0
    let xPosition = Int.random(in: 20...400)
    let yPosition = Int.random(in: 20...800)
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        let porobability = Int(arc4random_uniform(100))
        switch porobability {
        case 0...39:
            self.backgroundColor = .red
            self.points = 1
        case 40...69:
            self.backgroundColor = .systemPink
            self.points = 2
        case 70...84:
            self.backgroundColor = .green
            self.points = 5
        case 85...94:
            self.backgroundColor = .blue
            self.points = 8
        case 95...99:
            self.backgroundColor = .black
            self.points = 10
        default: print("error")
        }
        
        self.frame = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }
    
    func animation() {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.duration = 0.6
        springAnimation.fromValue = 1
        springAnimation.toValue = 0.8
        springAnimation.repeatCount = 1
        springAnimation.initialVelocity = 0.5
        springAnimation.damping = 1
        
        layer.add(springAnimation, forKey: nil)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
}
