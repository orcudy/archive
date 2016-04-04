//
//  Data.h
//  eWeek
//
//  Created by Christopher Orcutt on 3/1/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseDataFetcher.h"

@class Team;
@class Event;

@interface MasterData : NSObject <ParseDataFetcherCallBackMethods>
- (void)fetchData;
@end

@interface MasterData (Collections)
//Event
@property (nonatomic, strong, readonly) NSArray *events;
//Team
@property (nonatomic, strong, readonly) NSArray *teams;
@end