//
//  RankingDataModel.m
//  Schedule
//
//  Created by Christopher Orcutt on 3/9/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "RankingDataModel.h"
#import "Leaderboard.h"
#import "Event.h"
#import "Globals.h"

@interface RankingDataModel ()
@property (nonatomic, strong) Leaderboard *leaderboard;
@end

@implementation RankingDataModel

#pragma mark - Initialization

- (Leaderboard *)leaderboard{
    if (!_leaderboard){
        _leaderboard = [[Leaderboard alloc] init];
    }
    return _leaderboard;
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.leaderboard.dataSource = self;
        [self.leaderboard initData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"updateData" object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - API

- (Team *)teamAtIndex:(NSInteger)index{
    return [self.leaderboard teamWithRank:(index + 1)];
}

- (NSInteger)indexOfTeamWithName:(NSString *)name{
    return ([self.leaderboard rankForTeamWithName:name] - 1);
}

- (NSUInteger)totalNumberOfTeams{
    return [self.leaderboard.teams count];
}

#pragma mark - LeaderboardDataSourceProtocol

- (NSArray *)teamsForLeaderboard{
    return [Globals sharedInstance].masterData.teams;
}

#pragma mark - Auxilary Methods

- (void)fetchData{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:nil];
}

@end
