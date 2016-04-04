//
//  GameState.h
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"

@interface GameState : NSObject

@property (nonatomic, copy) NSString *mode;
@property (nonatomic, weak) Character *leftCharacter;
@property (nonatomic, weak) Character *rightCharacter;

/* -- Powerup State -- */
@property (nonatomic,assign) BOOL isSlowPowerupActive;
@property (nonatomic,assign) BOOL isFastPowerupActive;
@property (nonatomic,assign) BOOL isStopPowerupActive;
@property (nonatomic,assign) BOOL isGhostPowerupActive;
@property (nonatomic,assign) BOOL powerupIconsDisplayed;

/* -- Analytics -- */
@property (nonatomic,assign) NSInteger currentLevelNumber;
@property (nonatomic,assign) NSInteger numberOfFails;
/* -- -- -- -- -- -- -- -- -- -- -- */

+ (instancetype)sharedInstance;

@end
