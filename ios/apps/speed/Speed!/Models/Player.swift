//
//  Player.swift
//  Speed!
//
//  Created by Orcudy on 10/1/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import Foundation

class Player {
  var name: String
  var score: Int = 0
  var ready: Bool = false
  
  init(name: String) {
    self.name = name
  }
}