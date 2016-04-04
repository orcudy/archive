//
//  UIColor+ApplicationColors.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 8/1/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation

extension UIColor {
  static func colorFrom255(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    let red = r/255
    let green = g/255
    let blue = b/255
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
  
  static func applicationBlue() -> UIColor {
    return UIColor.colorFrom255(27, g: 162, b: 237)
  }
  
  static func applicationWhite() -> UIColor {
    return UIColor.colorFrom255(255, g: 255, b: 255)
  }
}