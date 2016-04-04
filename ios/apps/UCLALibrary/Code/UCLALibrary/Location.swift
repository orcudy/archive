//
//  Location.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 8/5/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation

class Location {
  let building: String?
  let street: String
  let city: String
  let ZIP: String
  let state: String
  let country: String
  
  let latitude: Float
  let longitude: Float
  
  init(building: String?, street: String, city: String, ZIP: String, state: String, country: String, latitude: Float, longitude: Float) {
    self.building = building
    self.street =  street
    self.city = city
    self.ZIP = ZIP
    self.state = state
    self.country = country
    self.latitude = latitude
    self.longitude = longitude
  }
}