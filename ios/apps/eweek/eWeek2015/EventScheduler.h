//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ParseDataFetcher.h"
#import "Event.h"

@interface EventScheduler : NSObject

@property (nonatomic, strong) id delegate;

- (instancetype)initWithDates:(NSArray *)dates andEvents:(NSArray *)events;
- (NSArray *)eventsForDate:(NSDate *)date;
- (void)addEvent:(Event *)object forDate:(NSDate *)date;
- (void)removeEvent:(Event *)object forDate:(NSDate *)date;
 
@end

@interface EventScheduler (Collections)
@property (nonatomic, strong, readonly) NSArray *dates;
@property (nonatomic, strong, readonly) NSArray *events;
@end

@protocol EventSchedulerDelegate <NSObject>
@optional
- (NSArray *)updateEvents;
- (NSArray *)updateDates;
@end