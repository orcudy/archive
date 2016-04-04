//
//  NSDate+Comparison.swift
//  DataManager
//
//  Created by Orcudy on 9/25/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import Foundation

extension NSDate {
  func daysFromDate(date: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    let unit = NSCalendarUnit.Day
    let comp = calendar.components(unit, fromDate: self, toDate: date, options: NSCalendarOptions.MatchFirst)
    return comp.day
  }
}