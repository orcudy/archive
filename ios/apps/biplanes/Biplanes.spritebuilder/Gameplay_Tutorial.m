//
//  Gameplay_Tutorial.m
//  Biplanes
//
//  Created by Chris Orcutt on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay_Tutorial.h"
#import "LoadScene.h"
#import "UserData.h"
#import "GameState.h"


typedef NS_ENUM(NSInteger, Region) {
    Region1,
    Region2,
    Region3
};

@implementation Gameplay_Tutorial {
    /* -- -- Dynamic changes based on tutorial progression -- -- */
    CCActionMoveTo *tutorial_cameraMove;
    CGFloat currentCharacterRotation;
    int numberOfTouches;
    
    //bool flags
    BOOL isRegion2AnimationComplete;
    BOOL tutorial_isFinished;
    BOOL tutorial_isCameraMoving;//needed for camera moving mech
    BOOL tutorial_isCameraMoved;//needed for camera moving mech
    BOOL tutorial_isBoundaryAdjusted;
    
    //from SpriteBuilder
    CCLabelTTF *_level1FlipCount;
    CCNode* _region2Checkpoint;

    // Set Up
    Character* currentCharacter;
    Region currentRegion;
    CCNode* biplanesText;
    
    //Restart Mechanism
    CCNode* _restartRegion1;
    CCNode* _restartRegion2;
    CCNode* _restartRegion3;
}


#pragma mark Tutorial Set-Up

-(void) didLoadFromCCB {
    [super didLoadFromCCB];
    
    currentRegion = Region1;
    numberOfTouches = 0;

    isRegion2AnimationComplete = NO;
    tutorial_cameraMove = NO;
    tutorial_isBoundaryAdjusted = NO;
    tutorial_isFinished = NO;
    tutorial_isCameraMoving = NO;
    tutorial_isCameraMoved = NO;
}

- (void) selectGameplaySettings {  
    [super selectGameplaySettings];
    
    if ([UserData getLastLevelPlayed] == 11) {
        biplanesText = [CCBReader load:@"Tutorials/Tutorial_Marlie_Region1"];
        currentCharacter = self.rightCharacter;
    }
    else{
        biplanesText = [CCBReader load:@"Tutorials/Tutorial_Charlie_Region1"];
        currentCharacter = self.leftCharacter;
    }
    [self addChild:biplanesText];
}

-(void) loadLevel{
    if ([UserData getLastLevelPlayed] == 11) {
        self.loadedLevel = (Level*) [CCBReader load:@"Level/Tutorial_Marlie" owner:self];
    }
    else{
        self.loadedLevel = (Level*) [CCBReader load:@"Level/Tutorial_Charlie" owner:self];
    }
    
    [self.currentLevel addChild:self.loadedLevel];
    self.currentLevel = self.loadedLevel;
}

#pragma mark Collision Handling

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character face_obstacle:(CCSprite *)nodeB {
    [self retry];
    return true;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character obstacle:(CCSprite *)nodeB {
    [self retry];
    return true;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character Finish:(CCNode *)nodeB {
    if (!currentCharacter.isFinished) {
        [self tutorial_isFinished];
        currentCharacter.isFinished = YES;
        currentCharacter.paused = YES;
    }
    return true;
}

-(void) tutorial_isFinished {
    if ([self.currentLevel.levelType isEqualToString:@"1playerRight"]) {
        CCNode* tapToContinue = [CCBReader load:@"TapToContinue"];
        [self addChild:tapToContinue];
    }
    else{
        CCNode* welcomeMessage = [CCBReader load:@"WelcomeScreen" owner:self];
        [self addChild:welcomeMessage];
    }
    tutorial_isFinished = YES;
}

-(void)story{
    [GameState sharedInstance].mode = @"story";
    [GameState sharedInstance].currentLevelNumber = 1;
    [GameState sharedInstance].numberOfFails = 0; //analytics
    [UserData setLastLevelPlayed:1];
    [LoadScene gameplay];
}

-(void) retry {
    if(currentRegion == Region1){
        [UserData setEndRegion:1];
    }
    else if (currentRegion == Region2){
        [UserData setEndRegion:2];
    }
    else if (currentRegion == Region3){
        [UserData setEndRegion:3];
    }
    [LoadScene gameplay_Tutorial];
}

#pragma mark Update

-(void)update:(CCTime)delta { 
    [super update:delta];

    //Check if character has reached checkopoint2, if so, start region2 processes of tutorial
    if (currentCharacter.positionInPoints.x >= _region2Checkpoint.positionInPoints.x && currentRegion == Region1){
        [self beginRegion2Action];
    }

    
    //Updates flip label during region2 processes of tutorial
    if (currentRegion == Region2){
        if (currentCharacter.rotation-currentCharacterRotation < -1760){
            _level1FlipCount.string = @"Onward!";
            [self completedRegion2Action];
        }
        else if (currentCharacter.rotation-currentCharacterRotation < -1400){
            _level1FlipCount.string = @"Do 1 flip.";
        }
        else if (currentCharacter.rotation-currentCharacterRotation < -1040){
            _level1FlipCount.string = @"Do 2 flips.";
        }
        else if (currentCharacter.rotation-currentCharacterRotation < -680){
            _level1FlipCount.string = @"Do 3 flips.";
        }
        else if (currentCharacter.rotation-currentCharacterRotation < -340){
            _level1FlipCount.string = @"Do 4 flips.";
        }
    }
}

-(void)beginRegion2Action{
    currentRegion = Region2;
    currentCharacterRotation = currentCharacter.rotation;
    currentCharacter.paused = YES;
    numberOfTouches = 0;

    CGRect percievedScreenSize = [self getPercievedScreenSize];
    self.charactersCenter.positionInPoints = _region2Checkpoint.positionInPoints;
    [self.physicsNode stopAllActions];
    CCActionFollow *follow = [CCActionFollow actionWithTarget:self.charactersCenter worldBoundary: percievedScreenSize];
    [self.physicsNode runAction:follow];
    
    [biplanesText.animationManager runAnimationsForSequenceNamed:@"Out"];
    [self.currentLevel.animationManager runAnimationsForSequenceNamed:@"actionAtCheckpoint2"];
}

-(CGRect)getPercievedScreenSize {
    CGRect percievedScreenSize;
    CGSize screenSize = [[CCDirector sharedDirector] viewSize];
    percievedScreenSize.origin = ccpSub(_region2Checkpoint.positionInPoints, ccp(screenSize.width/2, screenSize.height/2)) ;
    percievedScreenSize.size = screenSize;
    return percievedScreenSize;
}

-(void)region2AnimationCompleted{
    isRegion2AnimationComplete = YES;
}


-(void) completedRegion2Action {
    currentRegion = Region3;
    
    if (numberOfTouches >= 10) {
        [self.currentLevel.animationManager runAnimationsForSequenceNamed:@"flipsFinished_hint"];
    }
    else {
        [self.currentLevel.animationManager runAnimationsForSequenceNamed:@"flipsFinished_noHint"];
    }
}



-(void) completedRegion2Action_AdjustWorldBoundaries {
    [self.physicsNode stopAllActions];
    CCActionFollow *follow = [CCActionFollow actionWithTarget:self.charactersCenter worldBoundary: self.currentLevel.boundingBox];
    [self.physicsNode runAction:follow];
    tutorial_isBoundaryAdjusted = YES;
}



- (void) setCameraPosition {
    if(!tutorial_isBoundaryAdjusted && currentRegion == Region3){
        [self completedRegion2Action_AdjustWorldBoundaries];
    }
    
    if (!currentCharacter.paused && currentRegion != Region2) {
        if(currentRegion == Region3 && !tutorial_isCameraMoved){
            if (currentCharacter.positionInPoints.x <= _region2Checkpoint.positionInPoints.x) {
                if (!tutorial_isCameraMoving){
                    tutorial_isCameraMoving = YES;
                    tutorial_cameraMove = [CCActionMoveTo actionWithDuration:4.f position:ccp(0,0)];
                    [self.charactersCenter runAction:tutorial_cameraMove];
                }
                else if (currentCharacter.positionInPoints.x >= self.charactersCenter.positionInPoints.x){
                    self.charactersCenter.positionInPoints = currentCharacter.positionInPoints;
                    tutorial_isCameraMoved = YES;
                }
            }
            else if (currentCharacter.positionInPoints.x >= _region2Checkpoint.positionInPoints.x) {
                if (!tutorial_isCameraMoving){
                    tutorial_isCameraMoving = YES;
                    tutorial_cameraMove = [CCActionMoveTo actionWithDuration:4.f position:ccp(self.currentLevel.boundingBox.size.width,0)];
                    [self.charactersCenter runAction:tutorial_cameraMove];
                }
                else if (currentCharacter.positionInPoints.x <= self.charactersCenter.positionInPoints.x){
                    self.charactersCenter.positionInPoints = currentCharacter.positionInPoints;
                    tutorial_isCameraMoved = YES;

                }
            }
        }
        else{
            self.charactersCenter.positionInPoints = currentCharacter.positionInPoints;
        }
    }
}

- (void) checkBoundsOnCharacter:(Character*)character withTimeStep:(CGFloat)delta {
        if (currentRegion == Region2){
            CGRect percievedScreenSize = [self getPercievedScreenSize];
            if (!CGRectIntersectsRect(percievedScreenSize, character.boundingBox)) {
                [self retry];
            }
        }
        else{
            if (!CGRectIntersectsRect(self.currentLevel.boundingBox, character.boundingBox)) {
                [self retry];
            } 
        }
}

#pragma mark Touch Handling

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    numberOfTouches++;
    CGPoint touchLocation = [touch locationInNode:self];
    CGFloat halfScreenSize = [[CCDirector sharedDirector] viewSize].width/2;  
        
    if (currentRegion == Region2){
        if ([self.currentLevel.levelType isEqualToString:@"1player"] && touchLocation.x < halfScreenSize) {
            currentCharacter.paused = NO;
        }
        else if ([self.currentLevel.levelType isEqualToString:@"1playerRight"] && touchLocation.x > halfScreenSize){
            currentCharacter.paused = NO;
        }

        if (numberOfTouches == 7){
        [self.currentLevel.animationManager runAnimationsForSequenceNamed:@"hint"];
        }
    }
    
    if(tutorial_isFinished && [self.currentLevel.levelType isEqualToString:@"1playerRight"]){
        [LoadScene gameplay];
    }
    
    [super touchBegan:touch withEvent:event];
}
    
@end
