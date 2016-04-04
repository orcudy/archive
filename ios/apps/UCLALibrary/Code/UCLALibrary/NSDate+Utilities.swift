//
//  NSDate+Utilities.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 8/3/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation

extension NSDate {
  func indexForDate() -> Int {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let today = dateFormatter.stringFromDate(self)
    
    switch (today) {
    case "Monday":
      return 0
    case "Tuesday":
      return 1
    case "Wednesday":
      return 2
    case "Thursday":
      return 3
    case "Friday":
      return 4
    case "Saturday":
      return 5
    case "Sunday":
      return 6
    default:
      return 0
    }
  }
}