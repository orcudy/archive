//
//  ScheduleTableViewController.h
//  Schedule
//
//  Created by Christopher Orcutt on 3/8/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewController : UITableViewController

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *events;

@end
