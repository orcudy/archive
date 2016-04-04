//
//  ScrollToRefresh.h
//  eWeek_Ranking
//
//  Created by Christopher Orcutt on 3/10/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ScrollToRefresh : NSObject

@property (nonatomic, strong) UITableViewController *parentController;

- (void)setupScrollToRefresh;
- (void)refresh;
- (void)updateUI;

@end
