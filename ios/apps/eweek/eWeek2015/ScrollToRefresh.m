//
//  ScrollToRefresh.m
//  eWeek_Ranking
//
//  Created by Christopher Orcutt on 3/10/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "ScrollToRefresh.h"
#import "Globals.h"

@interface ScrollToRefresh()

@end

@implementation ScrollToRefresh

- (void) setupScrollToRefresh
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.parentController setRefreshControl:refreshControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"updateUI" object:nil];
    [self.parentController.refreshControl setTintColor:[Globals sharedInstance].nextApplicationColorTheme];

}

- (void) refresh
{
    [[Globals sharedInstance] changeApplicationColorTheme];
    [self.parentController.refreshControl setTintColor:[Globals sharedInstance].nextApplicationColorTheme];
    [self.parentController.refreshControl beginRefreshing];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
}

- (void)updateUI{    
    [((UINavigationController *)self.parentController.navigationController).navigationBar setBarTintColor:[Globals sharedInstance].applicationColorTheme];
    
    [((UITabBarController *)self.parentController.tabBarController).tabBar setTintColor:[Globals sharedInstance].applicationColorTheme];
    
    [self.parentController.tableView reloadData];
    [self.parentController.refreshControl endRefreshing];
    
}



@end
