//
//  DataManager.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 8/2/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation
import AFNetworking
import SwiftyJSON

//wrapper which provides unique way (ID) to lookup libraries in other VCs
class OperatingHoursData {
  var ID: String
  var operatingHours: [OperatingHours]
  
  init(ID: String, operatingHours: [OperatingHours]) {
    self.ID = ID
    self.operatingHours = operatingHours
  }
}

class DataManager {
  
  private let unitURL = "https://webservices.library.ucla.edu/libservices/units"
  private let baseDataURL = "https://webservices.library.ucla.edu/libservices/hours/unit/"
  private let manager = AFHTTPRequestOperationManager()
  
  //cache
  private var libraries: [Library]?
  
  // MARK: DataManagerAPI
  func dataForLibraries() {
    if let _ = self.libraries {
      postNotification("LibraryListDataReady", data: self.libraries)
      self.fetchAllLibraryData()
    } else {
      fetchLibraryUnitDataFromNetwork()
    }
  }
  
  func dataForLibraryWithID(ID: String) {
    let result = self.libraries?.filter { (element: Library) -> Bool in
      if element.ID == ID {
        if let operatingHours = element.operatingHours {
          let operatingHoursData = OperatingHoursData(ID: ID, operatingHours: operatingHours)
          self.postNotification("LibraryDataReady", data: operatingHoursData)
        } else {
          self.fetchLibraryDataFromNetwork(ID)
        }
      }
      return false
    }
    self.libraries = result
  }
  
  // MARK: Notifications
  private func postNotification(name: String, data: AnyObject?) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let notification: NSNotification
    if let data: AnyObject = data {
      let userInfo = ["data" : data]
      notification = NSNotification(name: name, object: nil, userInfo: userInfo)
    } else {
      notification = NSNotification(name: name, object: nil, userInfo: nil)
    }
    notificationCenter.postNotification(notification)
  }
  
  
  
  //MARK: AFNetworking
  private func fetchLibraryUnitDataFromNetwork() {
    manager.GET(unitURL, parameters: nil,
      success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let json = JSON(response)
        var libraryData = json["unit"]
        self.libraries = [Library]()
        for index in 0..<libraryData.count {
          let name = libraryData[index]["name"].string
          let ID = libraryData[index]["id"].string
          if let name = name, ID = ID {
            let libraries = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Libraries", ofType: "plist")!)
            if libraries?.objectForKey(ID) as? NSDictionary != nil {
              let library = Library(name: name, ID: ID)
              self.libraries!.append(library)
            }
          }
        }
        
        self.postNotification("LibraryListDataReady", data: self.libraries)
        self.fetchAllLibraryData()
        print("unit success")
      },
      failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        //TODO: implement failure condition -- note response internally failed August 5, 2015
        // idea: have unit data locally (check if it ever changes)
        print("failure: error \(error)")
        
        //                let libraryData = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("LibraryUnits", ofType: "plist")!)
        //
        //
        //                for index in 0..<libraryData!.count {
        //                    let name = libraryData[index]["name"].string
        //                    let ID = libraryData[index]["id"].string
        //                    if let name = name, ID = ID {
        //                        var library = Library(name: name, ID: ID)
        //                        self.libraries!.append(library)
        //                    }
        //                }
    })
  }
  
  private func fetchAllLibraryData() {
    if let libraries = libraries {
      for library in libraries {
        fetchLibraryDataFromNetwork(library.ID)
      }
    }
  }
  
  private func fetchLibraryDataFromNetwork(ID: String) {
    manager.GET(baseDataURL + ID, parameters: nil,
      success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        let json = JSON(response)
        let schedule = json["unitSchedule"]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let responseOpenKeys = ["monThursOpens", "monThursOpens", "monThursOpens", "monThursOpens", "friOpens", "satOpens", "sunOpens"]
        let responseCloseKeys = ["monThursCloses", "monThursCloses", "monThursCloses", "monThursCloses", "friCloses", "satCloses", "sunCloses"]
        
        var operatingHours = [OperatingHours]()
        for index in 0..<daysOfWeek.count {
          let openingDate = dateFormatter.dateFromString(schedule[responseOpenKeys[index]].string ?? "")
          let closingDate = dateFormatter.dateFromString(schedule[responseCloseKeys[index]].string ?? "")
          let hours = OperatingHours(day: daysOfWeek[index], opens: openingDate, closes: closingDate)
          operatingHours.append(hours)
        }
        
        self.libraries = self.libraries?.map { (element: Library) -> Library in
          if element.ID == ID {
            element.operatingHours = operatingHours
          }
          return element
        }
        
        let operatingHoursData = OperatingHoursData(ID: ID, operatingHours: operatingHours)
        self.postNotification("LibraryDataReady", data: operatingHoursData)
        print("success for \(ID)")
      },
      failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
        //TODO: implement failure condition
        print("failure: error \(error)")
        
        
    })
  }
}