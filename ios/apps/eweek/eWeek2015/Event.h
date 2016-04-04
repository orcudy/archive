//
//  Event.h
//  eWeek
//
//  Created by Christopher Orcutt on 2/21/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface Event : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *eventDescription;
@property (nonatomic,strong) NSString *locationName;
@property (nonatomic) CLLocationCoordinate2D *locationCoordinates;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;

+ (Event *)makeEventFromPFObject:(PFObject *)object;
@end
