//
//  Cache.swift
//  CODataManager
//
//  Created by Chris Orcutt (aka orcudy) on 9/24/15.
//  Copyright © 2015 Chris Orcutt. All rights reserved.
//

import Foundation
import RealmSwift

class Cache: Object {
  dynamic var name = String()
  dynamic var data = NSData()
  dynamic var valid = false
  dynamic var lastUpdated = NSDate()
}