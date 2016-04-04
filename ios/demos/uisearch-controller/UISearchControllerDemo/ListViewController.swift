//
//  ViewController.swift
//  UISearchControllerDemo
//
//  Created by Chris Orcutt on 7/28/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import UIKit

var data: [Person] = [Person]()

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController!
    
    //ViewController shown when search bar is activated
    var searchTableViewController: SearchTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data.append(Person(fname: "Chris", lname: "Orcutt", age: 23))
        data.append(Person(fname: "Jeremy", lname: "Orcutt", age: 21))
        data.append(Person(fname: "Zack", lname: "Orcutt", age: 19))
        data.append(Person(fname: "Jamie", lname: "Castelar", age: 23))

        
        //programatically load searchTableViewController
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        searchTableViewController = storyboard.instantiateViewControllerWithIdentifier("searchTableViewController") as! SearchTableViewController
        
        //instantiate new UISearchController with seachTableViewController as controller presented 
        //when search bar is active
        searchController = UISearchController(searchResultsController: searchTableViewController)
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self

        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        //set delegate and datasource for current VC's tableView
        tableView.tableHeaderView = searchController.searchBar
        tableView.dataSource = self
        tableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: UISearchResultsUpdating
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        var searchString = searchController.searchBar.text
        if !searchString.isEmpty {
            searchString = searchString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            searchString = searchString.lowercaseString
        
            var searchAge: Int?
            
            if let age = searchString.toInt() {
                searchAge = age
            }
            
            var predicate = NSPredicate(format: "firstName.lowercaseString CONTAINS %@ OR lastName.lowercaseString CONTAINS %@ OR age = %i", searchString.lowercaseString, searchString.lowercaseString, searchAge ?? 0)
            
            var filteredData = (data as NSArray).filteredArrayUsingPredicate(predicate)
            
            (searchController.searchResultsController as! SearchTableViewController).results = filteredData as! [Person]
            (searchController.searchResultsController as! SearchTableViewController).tableView.reloadData()
        }
    }
}

// MARK: UISearchControllerDelegate
extension ListViewController: UISearchControllerDelegate {
}

//MARK: UISearchBarDelegate
extension ListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: UITableViewDelegate 
extension ListViewController: UITableViewDelegate {
    
}

// MARK: UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell") as! UITableViewCell
        cell.textLabel?.text = data[indexPath.row].firstName
        return cell
    }
}

