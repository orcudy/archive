//
//  Library.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 7/16/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation

class OperatingHours {
  var day: String
  var closes: NSDate?
  var opens: NSDate?
  
  init(day: String, opens: NSDate?, closes: NSDate?) {
    self.day = day
    self.opens = opens
    self.closes = closes
  }
}

enum State: Int {
  case Open = 2
  case ClosingSoon = 1
  case Closed = 0
}

class Library: NSObject {
  let name: String
  let ID: String
  
  let imageName: String
  let location: Location
  var state: State?
  
  var operatingHours: [OperatingHours]?
  var dataLastRetrieved: NSTimeInterval
  
  init(name: String, ID: String) {
    let libraries = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Libraries", ofType: "plist")!)
    let library = (libraries?.objectForKey(ID) as? NSDictionary)!
    
    let name = library.objectForKey("name") as! String
    let imageName = library.objectForKey("imageName") as! String
    let building = library.objectForKey("building") as? String
    let street = library.objectForKey("street") as! String
    let city = library.objectForKey("city") as! String
    let ZIP = library.objectForKey("ZIP") as! String
    let state = library.objectForKey("state") as! String
    let country = library.objectForKey("country") as! String
    let latitude = library.objectForKey("latitude") as! Float
    let longitude = library.objectForKey("longitude") as! Float
    
    self.name = name
    self.ID = ID
    self.imageName = imageName
    
    self.dataLastRetrieved = 0
    self.location = Location(building: building, street: street, city: city, ZIP: ZIP, state: state, country: country, latitude: latitude, longitude: longitude)
    
  }
  
  func updateState() {
    let index = NSDate().indexForDate()
    if let opens = self.operatingHours?[index].opens, closes = self.operatingHours?[index].closes {
      let calendar = NSCalendar.currentCalendar()
      
      let components: NSCalendarUnit = [ .Hour, .Minute ]
      let todayComponents = calendar.components(components, fromDate: NSDate())
      let todayHour = todayComponents.hour
      let todayMinute = todayComponents.minute
      
      let openComponents = calendar.components(components, fromDate: opens)
      let openHour = openComponents.hour
      let openMinute = openComponents.minute
      
      let closeComponents = calendar.components(components, fromDate: closes)
      let closeHour = closeComponents.hour
      let closeMinute = closeComponents.minute
      
      let openHourDifference = (todayHour - openHour) * secondsInHour
      let openMinuteDifference = (todayMinute - openMinute) * secondsInMinute
      let openTimeDifference = openHourDifference + openMinuteDifference
      
      let closeHourDifference = (closeHour - todayHour) * secondsInHour
      let closeMinuteDifference = (closeMinute - todayMinute) * secondsInMinute
      let closeTimeDifference = closeHourDifference + closeMinuteDifference
      
      //            println()
      //            println("-- \(self.name) --")
      //            println("closes: \(closes)")
      //            println("opens: \(opens)")
      //            println("closeTimeDifference: \(closeTimeDifference)")
      //            println("openTimeDifference: \(openTimeDifference)")
      
      
      if secondsInHour > closeTimeDifference && closeTimeDifference > 0 {
        self.state = .ClosingSoon
      } else if openTimeDifference > 0 && closeTimeDifference > 0 {
        self.state = .Open
      } else {
        self.state = .Closed
      }
    } else {
      self.state = nil
    }
  }
  
  
  
  
}