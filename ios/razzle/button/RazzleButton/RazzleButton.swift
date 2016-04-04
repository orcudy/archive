//
//  RazzleButton.swift
//  RazzleButton
//
//  Created by Chris Orcutt on 1/3/16.
//  Copyright © 2016 Chris Orcutt. All rights reserved.
//

import UIKit

@IBDesignable
class RazzleButton: UIButton {
  
  @IBOutlet var view: UIView!
  @IBOutlet weak var highlightView: UIView!
  @IBOutlet weak var buttonView: UIView!

  var container: UIView!
  var cornerRadius: CGFloat! {
    didSet {
      self.layer.cornerRadius = cornerRadius
      self.buttonView.layer.cornerRadius = cornerRadius
      self.highlightView.layer.cornerRadius = cornerRadius
    }
  }
  
  @IBInspectable
  var color: UIColor! {
    didSet {
      self.buttonView.backgroundColor = color
      
      var hue: CGFloat = 0.0
      var saturation: CGFloat = 0.0
      var brightness: CGFloat = 0.0
      var alpha: CGFloat = 0.0
      color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
      
      
      let highlightColor = UIColor(hue: hue, saturation: saturation, brightness: brightness - 0.2, alpha: alpha)
      highlightView.backgroundColor = highlightColor
    }
  }
  
  @IBInspectable
  var icon: UIImage? {
    didSet {
      updateButton()
    }
  }
  
  @IBInspectable
  var textOffset: CGFloat = 0 {
    didSet {
      updateButton()
    }
  }
  
  @IBInspectable
  var spacing: CGFloat = 0 {
    didSet {
      updateButton()
    }
  }

  // MARK: Initialization
  private func baseInit(){
    let bundle = NSBundle(identifier: "com.orcudy.RazzleButton")
    bundle!.loadNibNamed("RazzleButton", owner: self, options: nil)
    
    self.addSubview(self.view)
    self.view.frame = bounds
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    baseInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    baseInit()
  }
  
  // MARK: Helpers
  private func updateButton() {

    //cleanup old button
    if let container = container {
      container.removeFromSuperview()
    }
    
    self.cornerRadius = 4
    let iconImageView = UIImageView(image: icon)
    
    //create label
    var attributes = [String : AnyObject]()
    attributes[NSFontAttributeName] = self.titleLabel?.font
    attributes[NSForegroundColorAttributeName] = self.titleLabel?.textColor
    attributes[NSBaselineOffsetAttributeName] = textOffset
    let label = UILabel.constrainedLabel(NSAttributedString(string: self.titleLabel!.text!, attributes: attributes), container: CGSize(width: self.frame.width, height: CGFloat.max))
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = true;

    //create container
    let buttonObjects = [iconImageView, label]
    let containerSize = buttonObjects.horizontalContainer(CGFloat(spacing ?? 0))
    container = UIView(frame: CGRect(x: 0, y: 0, width: containerSize.width, height: containerSize.height))
    
    //add views to container
    container.addSubviews(buttonObjects, spacing: CGFloat(spacing ?? 0), center: true)
    container.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    
    //add container to button
    self.view.addSubview(container)
    self.titleLabel?.layer.opacity = 0
  }
}
