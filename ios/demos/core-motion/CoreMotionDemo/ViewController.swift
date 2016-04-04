//
//  ViewController.swift
//  CoreMotionDemo
//
//  Created by Chris Orcutt on 7/15/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var greenSquare: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var control: UISegmentedControl!
    
    //manager provides all necessary methods and propertires
    let manager = CMMotionManager()
    let queue = NSOperationQueue.mainQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDeviceMotion()
    }
    
    @IBAction func resetButtonTapped(sender: AnyObject) {
        //reset greenSquare to its non-rotated state (rotation = 0)
        self.greenSquare.transform = CGAffineTransformMakeRotation(0)
        
        //position the center of the square to the center of the screen
        let screen = UIScreen.mainScreen().applicationFrame.size
        greenSquare.center = CGPoint(x: screen.width / 2, y: screen.height / 2)
    }
    
    //all core motion code (except manager instantiation) here!
    func setupDeviceMotion() {
        //make sure device has motion capabilities
        if manager.deviceMotionAvailable {
            //set the number of times the device should update motion data (in seconds)
            manager.deviceMotionUpdateInterval = 0.01
            //setup callback for everytime the motion data is updated
            manager.startDeviceMotionUpdatesToQueue(queue, withHandler: { (motion: CMDeviceMotion!, error: NSError!) -> Void in
                ///checking device attitude will allow us to check devices current orientation in 3D space
                var attitude = motion.attitude
                
                println("pitch: \(attitude.pitch)")
                println("roll: \(attitude.roll)")
                println("yaw: \(attitude.yaw)")
                
                //multiplier to manipulate effect of attitude change (based on slider)
                let multiplier = self.slider.value
                
                //select which dimension to move greenSquare by selecting segmentControl
                switch self.control.selectedSegmentIndex {
                //roll
                case 0:
                    self.greenSquare.center.x += CGFloat(attitude.roll * Double(multiplier))
                //pitch
                case 1:
                    self.greenSquare.center.y += CGFloat(attitude.pitch * Double(multiplier))
                //yaw
                case 2:
                    let angle = CGFloat(attitude.yaw * Double(multiplier))
                    self.greenSquare.transform = CGAffineTransformMakeRotation(angle)
                default:
                    break
                }
            })
        }
    }
}

