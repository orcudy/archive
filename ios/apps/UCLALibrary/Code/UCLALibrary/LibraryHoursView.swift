//
//  LibraryHoursView.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 7/18/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import UIKit

class LibraryHoursView: UIView {
  
  @IBOutlet var view: UIView!
  
  @IBOutlet weak var dayOfTheWeekLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var openingTimeLabel: UILabel!
  @IBOutlet weak var closingTimeLabel: UILabel!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSBundle.mainBundle().loadNibNamed("LibraryHoursView", owner: self, options: nil)
    self.addSubview(view)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    NSBundle.mainBundle().loadNibNamed("LibraryHoursView", owner: self, options: nil)
    bounds = view.bounds
    self.addSubview(view)
  }
  
}
