//
//  Team.m
//  eWeek
//
//  Created by Christopher Orcutt on 3/1/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Parse/Parse.h>

#import "Team.h"
#import "Event.h"

@implementation Team
+ (Team *)makeTeamFromPFObject:(PFObject *)object withEvents:(NSArray *)events{
    NSInteger totalPoints = 0;
    NSMutableDictionary *eventPointPairs = [[NSMutableDictionary alloc] init];
    for (Event *event in events){
        NSString *eventName = event.name;
        NSInteger points = (NSInteger)[[object objectForKey:event.ID] integerValue];
        totalPoints += points;
        NSNumber *pointsNumber = [NSNumber numberWithInteger:points];
        [eventPointPairs addEntriesFromDictionary:@{eventName : pointsNumber}];
    }
    Team *team = [[Team alloc] init];
    team.name = [object objectForKey:@"teamName"];
    team.totalPoints = totalPoints;
    team.eventPointPairs = eventPointPairs;
    return team;
}

@end
