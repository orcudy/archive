//
//  Leaderboard.m
//  Schedule
//
//  Created by Christopher Orcutt on 3/9/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "Leaderboard.h"
#import "Team.h"

@interface Leaderboard()
//Team (ranked in descending order)
@property (nonatomic, strong, readwrite) NSMutableArray *teams;
@end

@implementation Leaderboard

- (NSMutableArray *)teams{
    if (!_teams) {
        _teams = [[NSMutableArray alloc] init];
    }
    return _teams;
}

- (instancetype)init{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"updateData" object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - API

- (NSInteger)totalPointsForTeamWithName:(NSString *)name{
    for (Team *team in self.teams){
        if ([team.name isEqualToString:name]){
            return team.totalPoints;
        }
    }
    return NSNotFound;
}

- (NSUInteger)rankForTeamWithName:(NSString *)name{
    for (Team *team in self.teams){
        if ([team.name isEqualToString:name]){
            return ([self.teams indexOfObject:team] + 1);
        }
    }
    return NSNotFound;
}

- (Team *)teamWithRank:(NSInteger)rank{
    NSInteger index = (rank - 1);
    if (index < 0) {
        return nil;
    }
    return self.teams[index];
}

- (void)initData{
    [self fetchData];
}

#pragma mark - Helper Methods

- (NSArray *)sortTeamsByRank:(NSArray *)teams{
    NSArray *sortedTeams = [teams sortedArrayUsingComparator:^NSComparisonResult(Team *a, Team *b) {
        if (a.totalPoints > b.totalPoints){
            return (NSComparisonResult)NSOrderedAscending;
        }
        if (a.totalPoints < b.totalPoints){
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
        
    }];
    return sortedTeams;
}

#pragma mark - Selectors 

- (void)fetchData{
    self.teams = nil;
    self.teams = [[self.dataSource teamsForLeaderboard] mutableCopy];
    self.teams = [[self sortTeamsByRank:self.teams] mutableCopy];
}

@end
