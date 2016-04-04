//
//  RankingDetailModel.m
//  Schedule
//
//  Created by Christopher Orcutt on 3/9/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "EventScheduler.h"
#import "RankingDetailDataModel.h"
#import "Globals.h"
#import "Team.h"

@interface RankingDetailDataModel()
//NSString (eventName) : NSInteger (points)
@property (nonatomic, strong) NSMutableDictionary *eventPointPairs;
@property (nonatomic, strong) EventScheduler *eventScheduler;
@end

@implementation RankingDetailDataModel

#pragma mark - Initialization

- (NSMutableDictionary *)eventPointPairs{
    if (!_eventPointPairs){
        _eventPointPairs = [[NSMutableDictionary alloc] init];
        [self fetchEventPointPairs];
    }
    return _eventPointPairs;
}

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - API

- (Event *)eventAtIndex:(NSUInteger)index inSection:(NSUInteger)section{
    if (section >= [self.eventScheduler.dates count]){
        return nil;
    }
    
    NSDate *date = self.eventScheduler.dates[section];
    NSArray *eventsOnDate = [self.eventScheduler eventsForDate:date];
    
    if (index >= [eventsOnDate count]){
        return nil;
    }
    return eventsOnDate[index];
}

- (NSInteger)pointsForEventWithName:(NSString *)eventName{
    return (NSInteger)[[self.eventPointPairs objectForKey:eventName] integerValue];
}

- (NSArray *)eventsForDate:(NSDate *)date{
    return [self.eventScheduler eventsForDate:date];
}

- (NSUInteger)totalDates{
    return [self.eventScheduler.dates count];
}

- (NSDate *)dateAtIndex:(NSUInteger)index{
    if (index >= [self.eventScheduler.dates count]){
        return nil;
    }
    return self.eventScheduler.dates[index];
}

#pragma mark - Helper Methods

- (void)fetchData{
    [self fetchEventPointPairs];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:nil];
}

- (void)fetchEventPointPairs{
    NSArray *teams = [[Globals sharedInstance].masterData.teams mutableCopy];
    for (Team *team in teams){
        if ([team.name isEqualToString:self.teamName]){
            self.eventPointPairs = [team.eventPointPairs mutableCopy];
            break;
        }
    }
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
