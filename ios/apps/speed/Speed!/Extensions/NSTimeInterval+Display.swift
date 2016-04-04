//
//  NSTimeInterval+Display.swift
//  Speed!
//
//  Created by Orcudy on 10/1/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import Foundation

extension NSTimeInterval {
  func countDownString() -> String {
    let minutesRemaining = NSTimeInterval(Int(self / 60))
    let secondsRemaining = NSTimeInterval(self % (60))
    
    let minutesRemainingString = minutesRemaining.string()
    let secondsRemainingString = secondsRemaining.string()
    
    return minutesRemainingString + ":" + secondsRemainingString
  }
  
  func string() -> String {
    if self < 10 {
      return "0\(Int(self))"
    } else {
      return "\(Int(self))"
    }
  }
}