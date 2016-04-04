//
//  LibraryDetailViewController.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 7/16/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

let secondsInDay = 60 * 60 * 24

import UIKit
import MapKit
import AddressBook

class LibraryDisplayViewController: UIViewController {
  
  var library: Library!
  
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var verticalScrollView: UIScrollView!
  @IBOutlet weak var verticalScrollViewContentView: UIView!
  @IBOutlet weak var horizontalScrollView: UIScrollView!
  
  @IBOutlet weak var mapView: MKMapView!
  
  @IBAction func openInMapsButtonTapped(sender: AnyObject) {
    let latitude = library.location.latitude
    let longitude = library.location.longitude
    let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude) , longitude: CLLocationDegrees(longitude))
    
    let address = [String(kABPersonAddressStreetKey) as String: library.location.street as String,
      String(kABPersonAddressCityKey): library.location.city,
      String(kABPersonAddressStateKey): library.location.state,
      String(kABPersonAddressZIPKey): library.location.ZIP,
      String(kABPersonAddressCountryCodeKey): library.location.country]
    
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: address)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = library.name
    
    mapItem.openInMapsWithLaunchOptions(nil)
  }
  
  
  // MARK: ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = library.name
    self.imageView.image = UIImage(named: self.library.imageName)
    
    mapView.delegate = self
    let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(library.location.latitude), longitude: CLLocationDegrees(library.location.longitude))
    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    let region = MKCoordinateRegion(center: center, span: span)
    mapView.region = region
    let annotation = MKPointAnnotation()
    annotation.coordinate = center
    annotation.title = library.name
    //        annotation.subtitle = "My subtitle"
    mapView.addAnnotation(annotation)
    
    
    setupVerticalScrollView()
    setupHorizontalScrollView()
    setupNavigationBar()
  }
  
  override func viewWillAppear(animated: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "processLibraryData:", name: "LibraryDataReady", object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.removeObserver(self, name: "LibraryListDataReady", object: nil)
  }
  
  
  func processLibraryData(notification: NSNotification) {
    let data = notification.userInfo!
    let operatingHoursData = data["data"] as! OperatingHoursData
    let operatingHours = operatingHoursData.operatingHours
    let ID = operatingHoursData.ID
    
    if library.ID == ID {
      library.operatingHours = operatingHours
      library.updateState()
      setupHorizontalScrollView()
    }
  }
  
  func setupVerticalScrollView() {
    let width = UIView.screenSize().width
    let height = verticalScrollViewContentView.frame.height
    verticalScrollView.contentSize =  CGSize(width: width, height: height)
  }
  
  func timeIntervalToMonday() -> NSTimeInterval {
    let today = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "EEEE";
    let dayName = dateFormatter.stringFromDate(today)
    
    let daysFromMonday: Int
    switch (dayName) {
    case "Monday":
      daysFromMonday = 0
    case "Tuesday":
      daysFromMonday = 1
    case "Wednesday":
      daysFromMonday = 2
    case "Thursday":
      daysFromMonday = 3
    case "Friday":
      daysFromMonday = 4
    case "Saturday":
      daysFromMonday = 5
    case "Sunday":
      daysFromMonday = 6
    default:
      daysFromMonday = 0
    }
    return NSTimeInterval(secondsInDay * -daysFromMonday)
  }
  
  func setupHorizontalScrollView() {
    let count = library.operatingHours?.count ?? 0
    
    let calendar = NSCalendar.currentCalendar()
    for index in 0..<count {
      
      // CONote: using timeIntervalToMonday() to get the date for Monday because the UCLA webserivices
      // API (as of August 4 2015) only responds with the library times in chunks starting on Monday
      // and ending on Sunday
      let date = NSDate(timeIntervalSinceNow: NSTimeInterval(Int(timeIntervalToMonday()) + index * secondsInDay))
      let components: NSCalendarUnit = [ .Day ]
      let calendarComponents = calendar.components(components, fromDate: date)
      let dayNumber = calendarComponents.day
      
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "EEEE";
      let dayName = dateFormatter.stringFromDate(date)
      
      var openingTime = "LIBRARY"
      var closingTime = "CLOSED"
      if let opens = library.operatingHours?[index].opens, closes = library.operatingHours?[index].closes {
        openingTime = NSDateFormatter.localizedStringFromDate(opens, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        closingTime = NSDateFormatter.localizedStringFromDate(closes, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
      }
      
      let view = LibraryHoursView()
      view.frame.origin = CGPoint(x: CGFloat(index) * view.frame.width, y: 0)
      view.dayOfTheWeekLabel.text = dayName
      view.dateLabel.text = String(dayNumber)
      view.openingTimeLabel.text = openingTime
      view.closingTimeLabel.text = closingTime
      
      horizontalScrollView.addSubview(view)
    }
    
    let viewSize = LibraryHoursView().frame.size
    let width = viewSize.width * CGFloat(count)
    let height = viewSize.height
    horizontalScrollView.contentSize = CGSize(width: width, height: height)
  }
  
  func setupNavigationBar() {
    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("unwindToLibraryListView:"))
    backButton.image = UIImage(named: "backArrow")
    self.navigationItem.leftBarButtonItem = backButton
  }
  
  // MARK: Navigation
  func unwindToLibraryListView(sender: UIButton!) {
    navigationController?.popToRootViewControllerAnimated(true)
  }
}

// MARK: MKMapViewDelegate
extension LibraryDisplayViewController: MKMapViewDelegate {
  
}
