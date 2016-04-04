//
//  StartViewController.swift
//  Speed!
//
//  Created by Orcudy on 10/1/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
  
  // properties connected to our view objects in Interface Builder
  // the "@IBOutlet" keyword indicates to Xcode that these properties are connected to objects in Interface Builder (IB)
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var bottomView: UIView!
  
  // properties connected to our "Ready" buttons in IB
  @IBOutlet weak var topReadyButton: UIButton!
  @IBOutlet weak var bottomReadyButton: UIButton!

  // `Player` is a custom class that is defined in the Player.swift file
  // because we have two players in our game, we need two `instances` of the `Player` class
  let topPlayer = Player(name: "Top Player")
  let bottomPlayer = Player(name: "Bottom Player")

  // MARK: - LifeCycle
  
  // method defined by UIViewController class
  // called after our view is finished loading
  // (this method is only called ONCE, the very first time we see our Start Screen)
  override func viewDidLoad() {
    topReadyButton.transform.rotate(degrees: 180)
  }
  
  // method defined by UIViewController class
  // called before our view appears on screen
  // (this method is called EVERYTIME we see our Start Scene)
  override func viewWillAppear(animated: Bool) {
    topReadyButton.setTitleColor(UIColor.blue(), forState: UIControlState.Normal)
    topView.backgroundColor = UIColor.whiteColor()
    
    bottomReadyButton.setTitleColor(UIColor.red(), forState: UIControlState.Normal)
    bottomView.backgroundColor = UIColor.whiteColor()
  }
  
  // MARK: - Navigation 
  
  // special method that allows us to undue segues
  @IBAction func unwindToStart(segue: UIStoryboardSegue) {
    topPlayer.ready = false
    topPlayer.score = 0
    
    bottomPlayer.ready = false
    bottomPlayer.score = 0
    
  }
  
  // called before every segue
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "gameplayTransition" {
      let destinationViewController = segue.destinationViewController as! GameplayViewController
      destinationViewController.topPlayer = topPlayer
      destinationViewController.bottomPlayer = bottomPlayer
    }
  }
  
  // MARK: - GameLogic
  
  // called whenever the top "Ready" button is pressed
  // (the "@IBAction" indicates to Xcode that this method is connecting to something in Interface Builder)
  @IBAction func topReadyButtonTapped(sender: UIButton) {
    topReadyButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    topView.backgroundColor = UIColor.blue()
    topPlayer.ready = true
    startGame()
  }
  
  // called whenever the bottom "Ready" button is pressed
  @IBAction func bottomReadyButtonTapped(sender: UIButton) {
    bottomReadyButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    bottomView.backgroundColor = UIColor.red()
    bottomPlayer.ready = true
    startGame()
  }
  
  // called to check (and optionally) start the game
  func startGame() {
    if topPlayer.ready && bottomPlayer.ready {
      self.performSegueWithIdentifier("gameplayTransition", sender: self)
    }
  }
  
}