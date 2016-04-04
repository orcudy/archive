//
//  CALayer+Rotate.swift
//  Speed!
//
//  Created by Orcudy on 10/1/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import UIKit

extension CGAffineTransform {
  mutating func rotate(degrees degrees: CGFloat) {
    let radians = degrees * CGFloat((M_PI / 180))
    self = CGAffineTransformRotate(CGAffineTransformIdentity, radians)
  }
  
  mutating func rotate(radians radians: CGFloat) {
    self = CGAffineTransformRotate(CGAffineTransformIdentity, radians)
  }
}