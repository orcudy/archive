//
//  Event.m
//  eWeek
//
//  Created by Christopher Orcutt on 3/1/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (Event *)makeEventFromPFObject:(PFObject *)object{
    Event *event = [[Event alloc] init];
    event.name = [object objectForKey:@"name"];
    event.ID = [object objectForKey:@"ID"];
    event.eventDescription = [object objectForKey:@"description"];
    event.locationName = [object objectForKey:@"locationName"];
    //event.locationCoordinates = [[object objectForKey:@"locationCoordinates"] locationCoordinates];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    event.date = [dateFormatter dateFromString:[object objectForKey:@"eventDate"]];
    event.startTime = [object objectForKey:@"startTime"];
    event.endTime = [object objectForKey:@"endTime"];
    return event;
}
@end