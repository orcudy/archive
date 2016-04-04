//
//  RankingDataModel.h
//  Schedule
//
//  Created by Christopher Orcutt on 3/9/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Leaderboard.h"
#import "Team.h"

@interface RankingDataModel : NSObject <LeaderboardDataSource>

- (Team *)teamAtIndex:(NSInteger)index;
- (NSInteger)indexOfTeamWithName:(NSString *)name;
- (NSUInteger)totalNumberOfTeams;

@end
