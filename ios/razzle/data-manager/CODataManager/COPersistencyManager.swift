//
//  COPersistencyManager.swift
//  CODataManager
//
//  Created by Chris Orcutt (aka orcudy) on 9/24/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation
import RealmSwift

class COPersistencyManager {
  
  internal func retrieveCache(ID: String) -> Cache? {
    do {
      let realm = try Realm()
      let predicate = NSPredicate(format: "name == %@", ID)
      let caches = realm.objects(Cache).filter(predicate)
      return caches.first
    } catch {
      print("Realm error: could not access realm")
    }
    return nil
  }
  
  internal func cacheData(ID: String, data: NSData) {
    do {
      let predicate = NSPredicate(format: "name == %@", ID)
      let realm = try Realm()
      let caches = realm.objects(Cache).filter(predicate)
      
      if let cache = caches.first {
        //cache exists
        try realm.write {
          cache.data = data
          cache.valid = true
          cache.lastUpdated = NSDate()
        }
      } else {
        //cache does not yet exist, so create it
        try realm.write {
          let cache = Cache()
          cache.name = ID
          cache.data = data
          cache.valid = true
          cache.lastUpdated = NSDate()
          realm.add(cache)
        }
      }
    } catch {
      print("Realm error: unable to cache data")
    }
  }
}