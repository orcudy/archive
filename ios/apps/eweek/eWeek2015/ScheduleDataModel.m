//
//  ScheduleDataModel.m
//  Schedule
//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "ScheduleDataModel.h"
#import "EventScheduler.h"
#import "Globals.h"

@interface ScheduleDataModel()

@end

@implementation ScheduleDataModel

#pragma mark - Initialization

- (instancetype)init{
    self = [super init];
    if (self){
        [self initEventScheduler];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"updateData" object:nil];
    }
    return self;
}

- (void)initEventScheduler{
    NSArray *events = [Globals sharedInstance].masterData.events;
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    for (Event *event in events){
        if (event.date){
            [dates addObject:event.date];
        }
    }
    self.eventScheduler = [[EventScheduler alloc] initWithDates:[dates copy] andEvents:events];
    self.eventScheduler.delegate = self;
}

#pragma mark - API

- (ScheduleTableViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard{
    
    if (index >= [self.eventScheduler.dates count]){
        return nil;
    }
    
    ScheduleTableViewController *scheduleTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"ScheduleTableViewController"];
    scheduleTableViewController.events = self.eventScheduler.events[index];
    scheduleTableViewController.date = self.eventScheduler.dates[index];
    return scheduleTableViewController;
}

- (NSUInteger)indexOfViewController:(ScheduleTableViewController *)viewController{
    NSArray *dates = self.eventScheduler.dates;
    return [dates indexOfObject:viewController.date];
}

#pragma mark - Helper Methods
- (void)fetchData{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:nil];
}


#pragma mark - PageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ScheduleTableViewController *)viewController];
    
    if (index == 0 || index == NSNotFound){
        return nil;
    }
    
    --index;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ScheduleTableViewController *)viewController];
    
    if (index == NSNotFound){
        return nil;
    }
    
    ++index;
    if (index == [self.eventScheduler.dates count]){
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.eventScheduler.dates count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 1;
}

#pragma mark - EventSchedulerDataRefreshProtocol

- (NSArray *)updateEvents{
    return [Globals sharedInstance].masterData.events;
}

- (NSArray *)updateDates{
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSArray *events = [Globals sharedInstance].masterData.events;
    for (Event *event in events){
        if (event.date){
            [dates addObject:event.date];
        }
    }
    return [dates copy];
}

@end
