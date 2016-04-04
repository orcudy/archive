//
//  Array+UIViewContainer.swift
//  RazzleButton
//
//  Created by Chris Orcutt on 1/5/16.
//  Copyright © 2016 Chris Orcutt. All rights reserved.
//

import UIKit

extension Array where Element:UIView {
  func horizontalContainer(spacing: CGFloat) -> CGSize {
    var size = CGSize(width: 0, height: 0)
    for view in self {
      size.width += view.frame.width
      if (view.frame.height > size.height){
        size.height = view.frame.height
      }
    }
    size.width += spacing * CGFloat(self.count - 1)
    return size
  }
}