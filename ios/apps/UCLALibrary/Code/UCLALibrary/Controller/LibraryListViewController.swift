//
//  ViewController.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 7/16/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

//TODO: Find a better place for these
let secondsInHour = 3600
let secondsInMinute = 60

let green = UIImage(named: "greenIndicator")
let yellow = UIImage(named: "yellowIndicator")
let red = UIImage(named: "redIndicator")



import UIKit

class LibraryListViewController: UIViewController {
  
  var dataManager: DataManager!
  var libraries: [Library]?
  
  @IBOutlet weak var librariesTableView: UITableView!
  
  // MARK: ViewLifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    librariesTableView.dataSource = self
    librariesTableView.delegate = self
    //        librariesTableView.layer.cornerRadius = 5
    librariesTableView.separatorStyle = .None
  }
  
  override func viewWillAppear(animated: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(self, selector: "processLibraryListData:", name: "LibraryListDataReady", object: nil)
    notificationCenter.addObserver(self, selector: "processLibraryData:", name: "LibraryDataReady", object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.removeObserver(self, name: "LibraryListDataReady", object: nil)
    notificationCenter.removeObserver(self, name: "LibraryDataReady", object: nil)
  }
  
  
  
  // MARK: Notifications
  func processLibraryListData(notification: NSNotification) {
    let data = notification.userInfo!
    let libraries: AnyObject = data["data"]!
    self.libraries = (libraries as! [Library])
    librariesTableView.reloadData()
  }
  
  func processLibraryData(notification: NSNotification) {
    let data = notification.userInfo!
    let operatingHoursData = data["data"] as! OperatingHoursData
    let operatingHours = operatingHoursData.operatingHours
    let ID = operatingHoursData.ID
    
    let predicate = NSPredicate(format: "ID == %@", ID)
    let library = (libraries! as NSArray).filteredArrayUsingPredicate(predicate)
    if let library = library.first as? Library {
      library.operatingHours = operatingHours
      library.updateState()
      sortResults()
      librariesTableView.reloadData()
    }
  }
  
  func sortResults() {
    self.libraries?.sortInPlace() {(a, b) -> Bool in
      if a.state?.rawValue > b.state?.rawValue {
        return true
      } else if a.state?.rawValue == b.state?.rawValue {
        return a.name < b.name
      } else {
        return false
      }
    }
  }
  
  // MARK: Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showLibraryDisplayViewController" {
      let destination = segue.destinationViewController as! LibraryDisplayViewController
      let indexPath = self.librariesTableView.indexPathForSelectedRow!
      destination.library = libraries?[(indexPath.row)]
    }
  }
}

// MARK: UITableViewDataSource
extension LibraryListViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return libraries?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("libraryListCell") as! LibraryListTableViewCell
    if let library = libraries?[indexPath.row] {
      cell.libraryNameLabel.text = library.name
      cell.libraryIndicatorImage.image = determineLibraryCellImage(library, cell: cell)
      cell.libraryHoursLabel.text = determineLibraryCellHours(library)
    }
    return cell
  }
  
  func determineLibraryCellImage(library: Library, cell: LibraryListTableViewCell) -> UIImage? {
    if let state = library.state {
      cell.libraryIndicatorImage.layer.hidden = false
      switch state {
      case .Open:
        return green!
      case .ClosingSoon:
        return yellow!
      case .Closed:
        return red!
      }
    }
    return nil
  }
  
  func determineLibraryCellHours(library: Library) -> String {
    let index = NSDate().indexForDate()
    if let opens = library.operatingHours?[index].opens, closes = library.operatingHours?[index].closes {
      let openingTime = NSDateFormatter.localizedStringFromDate(opens, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
      let closingTime = NSDateFormatter.localizedStringFromDate(closes, dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
      return "\(openingTime) - \(closingTime)"
    } else {
      return "Hours not available"
    }
  }
}

// MARK: UITableViewDelegate
extension LibraryListViewController: UITableViewDelegate {
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}



