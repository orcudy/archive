//
//  Data.m
//  eWeek
//
//  Created by Christopher Orcutt on 3/1/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "MasterData.h"
#import "Event.h"
#import "Team.h"
#import "ParseDataFetcher.h"

@interface MasterData ()
//Event
@property (nonatomic, strong) NSMutableArray *events;
//Team
@property (nonatomic, strong) NSMutableArray *teams;
@property (nonatomic, strong) ParseDataFetcher *parseDataFetcher;
@end

@implementation MasterData

#pragma mark - Initialization

- (instancetype) init
{
    self = [super init];
    if(self){
        self.parseDataFetcher.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"refreshData" object:nil];
    }
    return self;
}

- (ParseDataFetcher *)parseDataFetcher{
    if (!_parseDataFetcher){
        _parseDataFetcher = [[ParseDataFetcher alloc] init];
    }
    return _parseDataFetcher;
}

- (NSArray *)events
{
    if (!_events){
        _events = [[NSMutableArray alloc] init];
    }
    return _events;
}

- (NSArray *)teams
{
    if (!_teams){
        _teams = [[NSMutableArray alloc] init];
    }
    return _teams;
}

#pragma mark - API

- (void)fetchData{
    [self.parseDataFetcher fetchDataWithClassName:@"Events"];
}

#pragma mark - ParseDataFetcherCallBackMethodsProtocol

- (void)dataFetchSucceeded:(NSArray *)data{
    if ([data count]){
        if ([((PFObject *)data[0]).parseClassName isEqualToString:@"Events"]){
            self.events = nil;
            for (PFObject *object in data){
                Event *event = [Event makeEventFromPFObject:object];
                [self.events addObject:event];
            }
            [self getRankingData];
        }
        
        if ([((PFObject *)data[0]).parseClassName isEqualToString:@"Rankings"]){
            self.teams = nil;
            for (PFObject *object in data){
                Team *team = [Team makeTeamFromPFObject:object withEvents:self.events];
                [self.teams addObject:team];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateData" object:nil];
        }
    }
}

- (void)dataFetchFailed{
    
}

#pragma mark - Helper Methods

- (void)getRankingData{
    [self.parseDataFetcher fetchDataWithClassName:@"Rankings"];
}

@end
