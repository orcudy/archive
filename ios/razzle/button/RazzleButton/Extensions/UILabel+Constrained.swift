//
//  NSAttributedString+Container.swift
//  RazzleButton
//
//  Created by Chris Orcutt on 1/5/16.
//  Copyright © 2016 Chris Orcutt. All rights reserved.
//

import UIKit

extension UILabel {
  static func constrainedLabel(attributedText: NSAttributedString, container: CGSize) -> UILabel{
    let boundingRect = attributedText.boundingRectWithSize(container, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil)
    let label = UILabel(frame: boundingRect)
    label.attributedText = attributedText
    return label
  }
}
