//
//  UserData.m
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import "UserData.h"
#import "Level.h"

@implementation UserData


/* -- -- -- -- -- Level Completed Status  -- -- -- -- -- */
+(void) setStatusOfLevel:(NSInteger)levelNum{
    NSUserDefaults *levelCompletionStatus = [NSUserDefaults standardUserDefaults];
    NSString *level = [NSString stringWithFormat:@"level%li", (long)levelNum];
    [levelCompletionStatus setBool:TRUE forKey:level];
    [levelCompletionStatus synchronize];
}

+(BOOL) getStatusOfLevel:(NSInteger)levelNum {
    NSUserDefaults *levelCompletionStatus = [NSUserDefaults standardUserDefaults];
    NSString *level = [NSString stringWithFormat:@"level%li", (long)levelNum];
    return [levelCompletionStatus boolForKey:level];
}

/* -- -- -- -- -- -- Last Level Played -- -- -- -- -- -- */
+(void) setLastLevelPlayed:(NSInteger)levelNum {
    NSUserDefaults *lastLevelPlayed = [NSUserDefaults standardUserDefaults];
    [lastLevelPlayed setInteger:levelNum forKey:@"last_level_played"];
    [lastLevelPlayed synchronize];
}

+(NSInteger) getLastLevelPlayed {
    NSUserDefaults *lastLevelPlayed = [NSUserDefaults standardUserDefaults];
    return [lastLevelPlayed integerForKey:@"last_level_played"];
}

/* -- -- -- -- -- -- High Scores Per Level -- -- -- -- -- -- */
+(void) setHighScoreForLevel:(NSInteger)levelNum withTime:(CGFloat)time {
    NSUserDefaults *highScore = [NSUserDefaults standardUserDefaults];
    NSString *level = [NSString stringWithFormat:@"HS_level%li", (long)levelNum];
    [highScore setFloat:time forKey:level];
    [highScore synchronize];
}

+(CGFloat) getHighScoreForLevel:(NSInteger)levelNum {
    NSUserDefaults *highScore = [NSUserDefaults standardUserDefaults];
    NSString *level = [NSString stringWithFormat:@"HS_level%li", (long)levelNum];
    return [highScore floatForKey:level];
}

/* -- -- -- -- -- -- Number Of Powerups -- -- -- -- -- -- */
+(void) setQuantity:(NSInteger)num forPowerup:(NSString*)powerup {
    NSUserDefaults *quanOfPower = [NSUserDefaults standardUserDefaults];
    NSString *powerupName = [NSString stringWithFormat:@"%@", powerup];
    [quanOfPower setInteger:num forKey:powerupName];
    [quanOfPower synchronize];
}

+(NSInteger) getQuantityForPowerup:(NSString*)powerup {
    NSUserDefaults *quanOfPower = [NSUserDefaults standardUserDefaults];
    return [quanOfPower integerForKey:powerup];
}

/* -- -- -- -- -- -- Tutorial Ending Position -- -- -- -- -- -- */
+(void) setEndRegion:(NSInteger)num {
    NSUserDefaults *endRegion = [NSUserDefaults standardUserDefaults];
    [endRegion setInteger:num forKey:@"end_region"];
    [endRegion synchronize];
}

+(NSInteger) getEndRegion{
    NSUserDefaults *endRegion = [NSUserDefaults standardUserDefaults];
    return [endRegion integerForKey:@"end_region"];
}


@end
