//
//  Analytics.m
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import "Analytics.h"
#import "GameState.h"

@implementation Analytics

+ (void)successWithTime:(CGFloat)time  {
    NSNumber* completionTime = [NSNumber numberWithFloat:time];
    NSNumber* levelnumber = [NSNumber numberWithLong:[GameState sharedInstance].currentLevelNumber];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: completionTime, @"completion_time", levelnumber, @"level_number", nil];
    [MGWU logEvent:@"level_success" withParams:params];
    [GameState sharedInstance].numberOfFails = 0;
}

+ (void)gameOverWithTime:(CGFloat)time withMessage:(NSString*)message  {
    NSNumber* failTime = [NSNumber numberWithFloat:time];
    NSNumber* levelnumber = [NSNumber numberWithLong:[GameState sharedInstance].currentLevelNumber];
    NSNumber* numberOfFails = [NSNumber numberWithLong:++[GameState sharedInstance].numberOfFails];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: failTime, @"fail_time", levelnumber, @"level_number", numberOfFails, @"numer_of_fails", message, @"fail_message", nil];
    [MGWU logEvent:@"level_fail" withParams:params];
}

+ (void) gaveUpOnLevel {
    NSNumber* level = [NSNumber numberWithLong:[GameState sharedInstance].currentLevelNumber];
    NSNumber* numberOfFails = [NSNumber numberWithLong:[GameState sharedInstance].numberOfFails];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: level, @"level_number", numberOfFails, @"numer_of_fails", nil];
    [MGWU logEvent:@"gave_up_on_level1 " withParams:params];
}

+ (void) clickTime:(CGFloat)time atTutorial:(NSString*)tutorial {
    NSNumber* clickTime = [NSNumber numberWithFloat:time];
    NSNumber* numberOfFails = [NSNumber numberWithLong:[GameState sharedInstance].numberOfFails];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: clickTime, @"click_time", tutorial, @"tutorialName", numberOfFails, @"numer_of_fails", nil];
    [MGWU logEvent:@"tutorial_button_click_time" withParams:params];
}

@end
