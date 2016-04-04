//
//  Character.h
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//


#import "CCNode.h"

@interface Character : CCNode

@property (nonatomic, copy) NSString *characterName;
@property (nonatomic, assign) BOOL isLeftCharacter;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL sidePressed;

@property (nonatomic, assign) CGFloat outOfBoundsCounter;
@property (nonatomic, assign) BOOL outOfBoundsMessageDisplayed;

@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) CGFloat turningRadius;

@property (nonatomic, assign) BOOL blinkSlowAnimationPlayed;
@property (nonatomic, assign) BOOL blinkFastAnimationPlayed;
@property (nonatomic, assign) BOOL blinkReallyFastAnimationPlayed;

- (void) getNewPosition;
- (void) getCharPosition;
- (void) putSmokeTrail;

@end

