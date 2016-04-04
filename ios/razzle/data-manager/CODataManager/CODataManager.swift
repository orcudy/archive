//
//  CODataManager.swift
//  CODataManager
//
//  Created by Chris Orcutt (aka orcudy) on 9/24/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation

enum COCachePolicy {
  case NetworkAlways
  case NetworkThenCache
  case CacheThenNetwork
}

typealias COParser = (NSData) -> Void

struct CODataParsingManager {
  private var parsers = [NSURL : COParser]()
  
  static func parseErrorMessage(url: String) {
    print("Parse Error: Problem parsing the response from \(url).")
  }
  
  mutating func addParser(url: NSURL, parser: COParser) {
    parsers[url] = parser
  }
  
  func requestParser(url: NSURL) -> COParser? {
    if let parser = parsers[url] {
      return parser
    }
    return nil
  }
}

class CODataManager {
  private var httpClient = COHTTPClient()
  private var persistencyManager = COPersistencyManager()
  private var dataParsingManager = CODataParsingManager()
  
  // MARK: - API
  
  func addRequest(url: NSURL, parser: COParser) {
    dataParsingManager.addParser(url, parser: parser)
  }
  
  func requestData(url: NSURL) {
    requestData(url, cachePolicy: .NetworkAlways)
  }
  
  func requestData(url: NSURL, cachePolicy: COCachePolicy) {
    if let parser = dataParsingManager.requestParser(url) {
      retrieveData(url, cachePolicy: cachePolicy, parser: parser)
    }
  }
  
  /**
  Helper function for library data retrieval.
  
  - parameters:
  - url: The URL where data is being requested.
  - callback: A method which is called to handle the data, once it is recieved from the network.
  */
  private func retrieveData(url: NSURL, cachePolicy: COCachePolicy, parser: COParser) {
    
    switch (cachePolicy) {
    case .NetworkAlways:
      httpClient.fetchData(url) { (data, response, error) -> Void in
        self.dataHandler(data, response: response, error: error, parser: parser)
      }
    case .NetworkThenCache:
      httpClient.fetchData(url) { (var data, response, error) -> Void in
        if let error = error {
          let ID = error.userInfo[NSURLErrorFailingURLStringErrorKey] as! String
          let cache = self.persistencyManager.retrieveCache(ID)
          data = cache?.data
        }
        self.dataHandler(data, response: response, error: error, parser: parser)
      }
    case .CacheThenNetwork:
      let cache = persistencyManager.retrieveCache("\(url)")
      if let data = cache?.data {
        dataHandler(data, response: nil, error: nil, parser: parser)
      } else {
        httpClient.fetchData(url) { (data, response, error) -> Void in
          self.dataHandler(data, response: response, error: error, parser: parser)
        }
      }
    }
  }
  
  /**
  Helper method that handles parsing JSON data, network response errors, and getting data from the cache.
  
  - parameters:
    - rawData: The raw data (as `NSData`) from the network request.
    - dataContainer: Data container where parsed data is to be stored.
    - response: Metadata from the network request.
    - error: Indicates whether an error occurred. If nil, no error occurred.
    - jsonParser: Method which handles all of the custom JSON parsing.
  */
  private func dataHandler(data: NSData?, response: NSURLResponse?, error: NSError?, parser: COParser) {
    let ID: String
    if let error = error {
      ID = error.userInfo[NSURLErrorFailingURLStringErrorKey] as! String
    } else {
      ID = "\((response?.URL)!)"
    }
    
    if let data = data {
      parser(data)
      persistencyManager.cacheData(ID, data: data)
    } else {
      CODataParsingManager.parseErrorMessage(ID)
    }
  }
}



