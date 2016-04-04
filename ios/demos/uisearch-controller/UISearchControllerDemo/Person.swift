//
//  People.swift
//  UISearchControllerDemo
//
//  Created by Chris Orcutt on 7/28/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import Foundation

class Person: NSObject {
    let firstName: String
    let lastName: String
    let age: Int
    
    init(fname: String, lname: String, age: Int) {
        firstName = fname
        lastName = lname
        self.age = age
    }
}