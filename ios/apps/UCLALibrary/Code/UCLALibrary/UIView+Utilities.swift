//
//  Utilities.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 8/2/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import UIKit

extension UIView {
  static func screenSize() -> CGSize {
    let width = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    return CGSize(width: width, height: height)
  }
  
  static func screenCenter() -> CGPoint {
    let screenSize = UIView.screenSize()
    let centerX = screenSize.width / 2
    let centerY = screenSize.height / 2
    return CGPoint(x: centerX, y: centerY)
  }
}