//
//  UIView+Utilities.swift
//  RazzleButton
//
//  Created by Chris Orcutt on 1/5/16.
//  Copyright © 2016 Chris Orcutt. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(views: [UIView], spacing: CGFloat, center: Bool){
    var cursor: CGFloat = 0
    for view in views {
      view.frame.origin = CGPoint(x: cursor, y: 0)
      cursor += view.frame.size.width + CGFloat(spacing)
      if (center){
        view.center = CGPoint(x: view.center.x, y: self.frame.height / 2)
      }
      self.addSubview(view)
    }
  }
}