//
//  AppDelegate.m
//  eWeek_Ranking
//
//  Created by Christopher Orcutt on 3/10/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "Globals.h"

#import "EventScheduler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"aRjmFcm2p1oyEZdaGz2EAVb8GAk2rpRXFkpPqZJn"
                  clientKey:@"s70ZR7yFCm9uo9qBlLhSebMtUYXE5HSL63aXmAIC"];
    
    [[Globals sharedInstance].masterData fetchData];
    
    [[Globals sharedInstance] changeApplicationColorTheme];
    
    NSString *headerFontName = [Globals sharedInstance].headerFontName;
    float headerFontSize = [Globals sharedInstance].headerFontSize;
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName : [UIFont fontWithName:headerFontName size:headerFontSize]}];
    
    [[UINavigationBar appearanceWhenContainedIn:[UITabBarController class], nil] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn:[UITabBarController class], nil] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearanceWhenContainedIn:[UITabBarController class], nil] setBarTintColor:[Globals sharedInstance].applicationColorTheme];
    
    [[UITabBar appearance] setTintColor:[Globals sharedInstance].applicationColorTheme];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithWhite:1.0 alpha:1.0]];

    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
