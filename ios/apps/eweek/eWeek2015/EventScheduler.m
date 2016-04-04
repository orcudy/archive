//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "EventScheduler.h"
#import "ParseDataFetcher.h"
#import "Event.h"

@interface EventScheduler ()

@property (nonatomic, strong, readwrite) NSMutableArray *dates;
@property (nonatomic, strong, readwrite) NSMutableArray *events;
//NSDate : NSMutableArray (holds all data objects ocurring on date)
@property (nonatomic, strong) NSMutableDictionary* dateEventPairs;

@end

@implementation EventScheduler

@synthesize dates = _dates;

#pragma mark - Initialization

- (NSMutableArray *)dates{
    if (!_dates) {
        _dates = [[NSMutableArray alloc] init];
    }
    return _dates;
}

- (NSMutableArray *)events{
    if (!_events) {
        _events = [[NSMutableArray alloc] init];
    }
    return _events;
}

- (NSMutableDictionary *)dateEventPairs{
    if (!_dateEventPairs){
        _dateEventPairs = [[NSMutableDictionary alloc] init];
    }
    return _dateEventPairs;
}

- (instancetype)initWithDates:(NSArray *)dates andEvents:(NSArray *)events{
    self = [super init];
    if (self){
        self.dates = [dates mutableCopy];
        self.dates = [[self sortDates:self.dates] mutableCopy];
        self.events = [events mutableCopy];
        for (Event *event in self.events){
            if (event && event.date ){
                [self addEvent:event forDate:event.date];
            }
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"updateData" object:nil];
    }
    return  self;
}

- (void)setDates:(NSMutableArray *)dates{
    for (NSDate *date in dates){
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *modifiedDate = [calendar dateFromComponents:dateComponents];
        if (![self.dates containsObject:modifiedDate]){
            [self.dates addObject:modifiedDate];
        }
    }
}


#pragma mark - API

- (NSArray *)eventsForDate:(NSDate *)date{
    NSString *key = [self keyForDate:date];
    return [self.dateEventPairs objectForKey:key];
}

- (void)addEvent:(Event *)event forDate:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *modifiedDate = [calendar dateFromComponents:dateComponents];
    if (![self.dates containsObject:modifiedDate]){
        if (modifiedDate){
            [self.dates addObject:modifiedDate];
        }
    }
    
    if (![self.events containsObject:event]){
        [self.events addObject:event];
    }
    
    NSString *key = [self keyForDate:date];
    
    NSMutableArray *eventsOnDate = [self.dateEventPairs objectForKey:key];
    if (eventsOnDate){
        [eventsOnDate addObject:event];
    } else {
        eventsOnDate = [[NSMutableArray alloc] init];
        [eventsOnDate addObject:event];
    }
    if (key){
        [self.dateEventPairs addEntriesFromDictionary:@{key : eventsOnDate}];
    }
}

- (void)removeEvent:(Event *)event forDate:(NSDate *)date{
    NSString *key = [self keyForDate:date];
    NSMutableArray *eventsOnDate = [self.dateEventPairs objectForKey:key];
    if (eventsOnDate){
        [eventsOnDate removeObject:event];
        if (![eventsOnDate count]){
            NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *modifiedDate = [calendar dateFromComponents:dateComponents];
            
            [self.dates removeObject:modifiedDate];
        } else {
            [self.dateEventPairs addEntriesFromDictionary:@{key : eventsOnDate}];
        }
    }
}

#pragma mark - Helper Methods

- (NSString *)keyForDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (NSArray *)sortDates:(NSArray *)dates{
    NSArray *sortedDates = [dates sortedArrayUsingComparator:^NSComparisonResult(NSDate *a, NSDate *b) {
        if ([a isEqualToDate:[a earlierDate:b]]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([b isEqualToDate:[a earlierDate:b]]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    return sortedDates;
}

- (void)fetchData{
    if ([self.delegate respondsToSelector:@selector(updateEvents)]){
        self.events = [[self.delegate updateEvents] mutableCopy];
    }
    
    if ([self.delegate respondsToSelector:@selector(updateDates)]){
        self.dates = [[self.delegate updateDates] mutableCopy];
    }
}

@end
