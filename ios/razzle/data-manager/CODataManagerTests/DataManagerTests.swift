//
//  DataManagerTests.swift
//  DataManager
//
//  Created by Orcudy on 9/26/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import XCTest
@testable import DataManager

class DataManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
  func testDaysFromDate_TwoDaysBeforeDate_ReturnsNegativeTwo() {
    let today = NSDate()
    let twoDaysBeforeToday = today.dateByAddingTimeInterval(-2 * 60 * 60 * 24)
    
    
    let result = today.daysFromDate(twoDaysBeforeToday)
    XCTAssertEqual(result, -2)
  }
}
