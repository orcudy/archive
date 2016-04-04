//
//  AppDelegate.swift
//  UCLALibrary
//
//  Created by Chris Orcutt on 7/16/15.
//  Copyright (c) 2015 Chris Orcutt. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataManager = DataManager()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //prefetch library list data
        dataManager.dataForLibraries()
        
        //dependency injection
        let libraryListViewController = (window?.rootViewController?.childViewControllers[0] as! LibraryListViewController)
        libraryListViewController.dataManager = dataManager
        
        
        //set custom navigation bar properties
        var textAttributes = [String : AnyObject]()
        textAttributes[NSForegroundColorAttributeName] = UIColor.applicationWhite()
        textAttributes[NSFontAttributeName] = UIFont(name: "Avenir-Medium", size: 25)
        
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor.applicationWhite()
        UINavigationBar.appearance().barTintColor = UIColor.applicationBlue()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().shadowImage = UIImage()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        dataManager.dataForLibraries()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

}

