//
//  COHTTPClient.swift
//  CODataManager
//
//  Created by Chris Orcutt (aka orcudy) on 9/24/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation

typealias DataCompletionHandler = (NSData?, NSURLResponse?, NSError?) -> Void

class COHTTPClient: NSObject {
  static func networkErrorMessage(error: NSError) {
    print("Network Error: The request to \(error.userInfo[NSURLErrorFailingURLStringErrorKey]!) received the following network error: \(error.userInfo[NSLocalizedDescriptionKey]!)")
  }
  
  internal func fetchData(url: NSURL, completionHandler: DataCompletionHandler) {
    //setup networking session
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: configuration)
    
    //start task
    let task = session.dataTaskWithURL(url, completionHandler: completionHandler)
    task.resume()
  }
}

