//
//  RankingDetailModel.h
//  Schedule
//
//  Created by Christopher Orcutt on 3/9/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventScheduler.h"

#import "Event.h"

@interface RankingDetailDataModel : NSObject <EventSchedulerDelegate>
@property (nonatomic, strong) NSString *teamName;

- (Event *)eventAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (NSInteger)pointsForEventWithName:(NSString *)eventName;
- (NSArray *)eventsForDate:(NSDate *)date;
- (NSDate *)dateAtIndex:(NSUInteger)index;
- (NSUInteger)totalDates;

@end
