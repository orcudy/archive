//
//  Leaderboard.h
//  Schedule
//
//  Created by Christopher Orcutt on 3/9/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Team;

@interface Leaderboard : NSObject
@property (nonatomic, strong) id dataSource;
- (NSInteger)totalPointsForTeamWithName:(NSString *)name;
- (NSUInteger)rankForTeamWithName:(NSString *)name;
- (Team *)teamWithRank:(NSInteger)rank;
- (void)initData;
@end

@interface Leaderboard (Collections)
//Team (ranked in descending order)
@property (nonatomic, strong, readonly) NSArray *teams;
@end

@protocol LeaderboardDataSource <NSObject>
@required
//Team
- (NSArray *)teamsForLeaderboard;
@end