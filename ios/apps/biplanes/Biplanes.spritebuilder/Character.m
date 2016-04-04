//
//  Character.m
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//


#import "Character.h"

@implementation Character {
    CGPoint _currentPosition;
    CGPoint _nextPosition;
}

-(void) didLoadFromCCB {
    self.rotation = 0;
    self.turningRadius = 4;
    self.speed = 2;
    self.paused = NO;
    self.outOfBoundsCounter = 4.0;
}

/*
 - Method called while player's finger is on the screen
 - Method changes rotation property of calling object 
 */
- (void) getNewPosition {    
    /* decrement to make player turn upward, instead of downward (convention of rotion property is that positive
     values are CW rotation)
     */
    self.rotation = self.rotation - _speed - _turningRadius;
    [self getCharPosition];
}

/*
 - Method called every frame (regardless of whether getNewPosition is called)
 - Method changes x and y position depedent on current heading of character (which is dictated by rotation)
 */
- (void) getCharPosition {
    CGFloat newX = cos(self.rotation*(M_PI/180)*1); //trig functions 
    CGFloat newY = sin((self.rotation*(M_PI/180)*-1));
    
    _currentPosition = [self positionInPoints];
     self.position = ccpAdd(_currentPosition, ccp(_speed*newX,_speed*newY)); 

}

- (void) putSmokeTrail {
    CCParticleSystem *smokeTrail = (CCParticleSystem*)[CCBReader load:@"Smoke"];
    smokeTrail.rotation = self.rotation;
    smokeTrail.positionInPoints = self.positionInPoints;
    smokeTrail.autoRemoveOnFinish = true;
    [self.parent addChild:smokeTrail];
}

@end