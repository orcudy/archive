//
//  Team.h
//  eWeek
//
//  Created by Christopher Orcutt on 2/22/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Team : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger totalPoints;
@property (nonatomic, strong) NSDictionary *eventPointPairs;

+ (Team *)makeTeamFromPFObject:(PFObject *)object withEvents:(NSArray *)events;

@end
