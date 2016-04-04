//
//  GameplayViewController.swift
//  Speed!
//
//  Created by Orcudy on 10/1/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import UIKit

class GameplayViewController: UIViewController {
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var bottomView: UIView!
  
  @IBOutlet weak var topScoreLabel: UILabel!
  @IBOutlet weak var bottomScoreLabel: UILabel!
  
  @IBOutlet weak var topTimerLabel: UILabel!
  @IBOutlet weak var bottomTimerLabel: UILabel!
  
  // player objects (passed in from the Start Scene)
  var topPlayer: Player!
  var bottomPlayer: Player!
  
  var isGameOver = false
  
  // timer used to update the amount of time remaining
  var timer: NSTimer!
  var timeRemaining: NSTimeInterval = 0 {
    // didSet allows us to run this code whenever the value of timeRemaining changes
    didSet {
      topTimerLabel.text = timeRemaining.countDownString()
      bottomTimerLabel.text = timeRemaining.countDownString()
    }
  }

  // MARK: LifeCycle
  
  override func viewDidLoad() {
      super.viewDidLoad()
    topScoreLabel.transform.rotate(degrees: 180)
    topTimerLabel.transform.rotate(degrees: 180)
    
    topScoreLabel.text = "0"
    bottomScoreLabel.text = "0"
    
    topView.backgroundColor = UIColor.blue()
    bottomView.backgroundColor = UIColor.red()
    
    timeRemaining = 30
    timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerTick", userInfo: nil, repeats: true)
  }
  
  // MARK: Timer
  
  func timerTick() {
    timeRemaining--
    if timeRemaining == 0 {
      gameOver()
    }
  }
  
  
  // MARK: - GameLogic
  
  @IBAction func topBlockTapped(sender: UITapGestureRecognizer) {
    if !isGameOver {
      topPlayer.score++
      topScoreLabel.text = "\(topPlayer.score)"
    } else {
      restartGame()
    }
  }

  @IBAction func bottomBlockTapped(sender: UITapGestureRecognizer) {
    if !isGameOver {
      bottomPlayer.score++
      bottomScoreLabel.text = "\(bottomPlayer.score)"
    } else {
      restartGame()
    }
  }
  
  func gameOver() {
    timer.invalidate()
    isGameOver = true
    if topPlayer.score > bottomPlayer.score {
      topScoreLabel.text = "You Win! =]"
      bottomScoreLabel.text = "You Lose! =["
    } else if bottomPlayer.score > topPlayer.score {
      topScoreLabel.text = "You Lose! =["
      bottomScoreLabel.text = "You Win! =]"
    } else {
      topScoreLabel.text = "You Tie! =|"
      bottomScoreLabel.text = "You Tie! =|"
    }
  }
  
  func restartGame() {
    self.performSegueWithIdentifier("unwindToStart", sender: self)
  }
  
}
