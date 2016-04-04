//
//  UserData.h
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData : NSObject

+(void) setLastLevelPlayed:(NSInteger)levelIndex;
+(NSInteger) getLastLevelPlayed;

+(void) setStatusOfLevel:(NSInteger) levelIndex;
+(BOOL) getStatusOfLevel:(NSInteger)levelIndex;

+(void) setHighScoreForLevel:(NSInteger)levelIndex withTime:(CGFloat)time;
+(CGFloat) getHighScoreForLevel:(NSInteger)levelIndex;

+(void) setQuantity:(NSInteger)num forPowerup:(NSString*)powerup;
+(NSInteger) getQuantityForPowerup:(NSString*)powerup;

+(void) setEndRegion:(NSInteger)num;
+(NSInteger) getEndRegion;



@end
