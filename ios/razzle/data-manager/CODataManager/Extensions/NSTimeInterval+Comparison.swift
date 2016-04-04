//
//  NSTimeInterval+Comparison.swift
//  DataManager
//
//  Created by Orcudy on 9/25/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import Foundation

extension NSTimeInterval {
  static func days(number: Int) -> NSTimeInterval {
    return NSTimeInterval(number) * 60 * 60 * 24
  }
}