//
//  ScheduleDataModel.h
//  Schedule
//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "EventScheduler.h"

@interface ScheduleDataModel : NSObject <UIPageViewControllerDataSource, EventSchedulerDelegate>

@property (nonatomic, strong) EventScheduler *eventScheduler;

- (ScheduleTableViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(ScheduleTableViewController *)viewController;

@end
