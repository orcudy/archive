//
//  Store.m
//  Biplanes
//
//  Created by Chris Orcutt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Store.h"
#import "UserData.h"

@implementation Store

-(void) bought3Powerups:(NSString*)powerup {
    if (powerup) {
        [self boughtNumber:3 ofPowerups:powerup];
    }
}

-(void) bought1Powerups:(NSString*)powerup {
    if (powerup) {
        [self boughtNumber:1 ofPowerups:powerup];
    }
}

-(void) boughtNumber:(NSInteger)number ofPowerups:(NSString*)powerup {
    NSInteger numPowerups = [UserData getQuantityForPowerup:powerup];
    [UserData setQuantity:(numPowerups+number) forPowerup:powerup];
}

-(void) back {
    [[CCDirector sharedDirector] popScene];
}


-(void) fast {
    CCLOG(@"Pressed: Fast");
    [MGWU testBuyProduct:@"com.chrisorcutt.biplanes.powerups.fast" withCallback:@selector(bought3Powerups:) onTarget:self];
}

-(void) slow {
    CCLOG(@"Pressed: Slow");
    [MGWU testBuyProduct:@"com.chrisorcutt.biplanes.powerups.slow" withCallback:@selector(bought3Powerups:) onTarget:self];
}

-(void) stop {
    CCLOG(@"Pressed: Stop");
    [MGWU testBuyProduct:@"com.chrisorcutt.biplanes.powerups.stopSpinners" withCallback:@selector(bought3Powerups:) onTarget:self];
}

-(void) ghost {
    CCLOG(@"Pressed: Ghost");
    [MGWU testBuyProduct:@"com.chrisorcutt.biplanes.powerups.ghost" withCallback:@selector(bought1Powerups:) onTarget:self];
}

-(void) restore {
    CCLOG(@"Pressed: Restore");
[MGWU testRestoreProducts:@[@"com.chrisorcutt.biplanes.powerups.slow", @"com.chrisorcutt.biplanes.powerups.fast", @"com.chrisorcutt.biplanes.powerups.stopSpinners", @"com.chrisorcutt.biplanes.powerups.ghost"] withCallback:@selector(restoredProducts:) onTarget:self];}
@end
