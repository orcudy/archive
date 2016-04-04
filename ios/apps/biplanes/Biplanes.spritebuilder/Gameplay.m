 //
//  Gameplay.m
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//  

#import "Gameplay_Protected.h"
#import "Level.h"
#import "GameState.h"
#import "LevelSelect.h"
#import <math.h>
#import "Analytics.h"
#import "UserData.h"
#import "AppDelegate.h"
#import "LoadScene.h"

static CGFloat noSpeed = 0.0;
static CGFloat slowSpeed = 0.8;
static CGFloat naturalSpeed = 1.2;
static CGFloat fastSpeed = 2;

@implementation Gameplay {
    
    /* -- -- -- Gameplay Set Up -- -- -- */
    //From SpriteBuilder
    CCLabelTTF *_levelName;
    CCNode *_rightCharacterSpawnPoint;
    CCNode *_leftCharacterSpawnPoint;
    BOOL levelSuccessMethodComplete; //hacky solution to the problem of calling levle success method too many times and causing level skips
    BOOL isGameplaySceneInitialized;
    BOOL isPhysicsNodePaused;

    
    
    /* -- -- Powerups -- -- */
    //From SpriteBuilder
    CCNode* powerups;
    CCLabelTTF* _powerupFast;
    CCLabelTTF* _powerupNormal;
    CCLabelTTF* _powerupSlow;
    CCLabelTTF* _powerupStop;
    CCLabelTTF* _powerupGhost;

    /* -- -- -- Position Updating & Checking -- -- -- */
    int numberOfTimesUpdateMethodCalled; //for setting smoke
    BOOL isCameraMoved;
    CCActionMoveTo *actionMoveTo;
    
    CCNode *CWSpinningObstacleNode;
    CCNode *CCWSpinningObstacleNode;
    CGFloat spinSpeed;
   
    
    /* -- -- -- -- Dynamic in-Game Changes -- -- -- -- */
    CCNode *overlayScreen;
    
    //From SpriteBuilder
    CCLabelTTF *_levelCompleteTime;
    CCLabelTTF *_levelCompleteBestTime;
    CCLabelTTF *message;

    CCButton* _pauseButton;
    CCButton* _retryButton;
    CCButton* _powerupButton;
    CCNode*   _powerupSelect;
    
    
    /* -- -- -- -- Arrow DropDown Variables -- -- -- -- */
    //From SpriteBuilder    
    CCNode* OutOfBoundsArrow_Blue;
    CCNode* OutOfBoundsArrow_Yellow;
  
    
    /* -- -- -- -- -- -- Touch Detection -- -- -- -- -- */
    UITouch *leftTouch;
    UITouch *rightTouch;
    

    /* -- Character Finished Drop Down Variables -- */
    CCLabelTTF *_characterFinishedText;
    CCNode *_characterFinished;

    
    /* -- -- -- -- -- -- Analytics variables -- -- -- -- -- -- */
    CCTime buttonTimer;
    BOOL tutorialButtonAnalyticsSent;
}

#pragma mark Scene Loading

- (void) didLoadFromCCB {    
    if ([[GameState sharedInstance].mode isEqualToString:@"story"]) {
        [self loadLevel];
    }
    
    /* -- -- -- Player will be set in store screen in final version -- -- -- */
    [GameState sharedInstance].leftCharacter = (Character*)[CCBReader load:@"Characters/Charlie" owner:self];
    [GameState sharedInstance].rightCharacter = (Character*)[CCBReader load:@"Characters/Marlie" owner:self];
    /* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  */
    
    _leftCharacter = [GameState sharedInstance].leftCharacter;
    _rightCharacter = [GameState sharedInstance].rightCharacter;
    
    [_physicsNode addChild:_leftCharacter];
    [_physicsNode addChild:_rightCharacter];
    
    [self selectGameplaySettings];
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = NO;
    _levelTimer = 0;
    
    //analyticss
    buttonTimer = 0;
    tutorialButtonAnalyticsSent = NO;
    
    numberOfTimesUpdateMethodCalled = 0;
    levelSuccessMethodComplete = NO; // initialization of hacky solution to the problem of calling levle success method too many times and causing level skips
    spinSpeed = naturalSpeed;
    isGameplaySceneInitialized = NO;
        
    
    [GameState sharedInstance].powerupIconsDisplayed = NO;
    [GameState sharedInstance].isSlowPowerupActive = NO;
    [GameState sharedInstance].isFastPowerupActive = NO;
    [GameState sharedInstance].isStopPowerupActive = NO;
    [GameState sharedInstance].isGhostPowerupActive = NO;
}

-(void) loadLevel {
    NSString* levelToLoad = [NSString stringWithFormat:@"Level/Level%li", (long)[GameState sharedInstance].currentLevelNumber];
    _loadedLevel = (Level*) [CCBReader load:levelToLoad owner:self];
    [_currentLevel addChild:_loadedLevel];
    _currentLevel = _loadedLevel;
    
    if (_levelName.string) {
        _levelName.string = _currentLevel.levelName;
    }
}

/* -- Selecting gameplay (number of characters & camera position dependent on level (tutorial or not)) -- */
- (void) selectGameplaySettings {
    if ([_currentLevel.levelType isEqualToString:@"1player"]){
        [_physicsNode removeChild:_rightCharacter];
        _rightCharacter = nil;
        isCameraMoved = YES;
        _leftCharacter.isFinished = NO;
    }
    else if ([_currentLevel.levelType isEqualToString:@"1playerRight"]){
        [_physicsNode removeChild:_leftCharacter];
        _leftCharacter = nil;
        isCameraMoved = YES;
        _rightCharacter.isFinished = NO;
    }
    else { 
         isCameraMoved = NO;
        _rightCharacter.isFinished = NO;
        _leftCharacter.isFinished = NO;
    }
}

- (void)onEnter {
    [super onEnter];
    if (!isGameplaySceneInitialized){
        isGameplaySceneInitialized = YES;
        if (_leftCharacterSpawnPoint) {
            _leftCharacter.positionInPoints = _leftCharacterSpawnPoint.positionInPoints;
        }

        if (_rightCharacterSpawnPoint) {
            _rightCharacter.positionInPoints = _rightCharacterSpawnPoint.positionInPoints;
        }

        CCActionFollow *follow = [CCActionFollow actionWithTarget:_charactersCenter worldBoundary: _currentLevel.boundingBox];
        [_physicsNode runAction:follow];
    }
    [self updatePowerupLabels];
}

-(void)onExit {
    [super onExit];
}

- (void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
}

#pragma mark Collision Detection - Finish

//Collision with chequered flag callback method
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character Finish:(CCNode *)nodeB {
    if ([self isCollisionValidByCharacter:character]){
        return [self levelCompletedByCharacter:character];
    }
    return false;
}

//sets the isFinished property of character to true, if both characters are finished begin protocol for displaying success screen
-(BOOL) levelCompletedByCharacter:(Character*) character {
    character.isFinished = YES;
    if (character.isLeftCharacter) {
        _leftCharacter.paused = YES;
    }
    else {
        _rightCharacter.paused = YES;
    }
    
    [self removeOutOfBoundsArrowForCharacter:character];

    
    if ((_leftCharacter.isFinished || [_currentLevel.levelType isEqualToString:@"1playerRight"]) && (_rightCharacter.isFinished || [_currentLevel.levelType isEqualToString:@"1player"])) {
        [self levelSuccess];
        return YES;
    }
    return NO;
}

//check to see if finishing time is fastest in history, display appropriate screen based.
-(void) levelSuccess {
    if (levelSuccessMethodComplete == NO) // hacky solution to release bug -- calling level success multiple times (I think its more efficient then post step solution though, after all the post step solution has to go throuhg a method call and then a comparison, mine is just a boolean comparison
    {
        levelSuccessMethodComplete = YES;
        NSInteger currentLevel = [GameState sharedInstance].currentLevelNumber;
        [Analytics successWithTime:_levelTimer];
        [UserData setStatusOfLevel:currentLevel];
        BOOL isBestTime = [self isBestTimeOnLevel:currentLevel];

        if (_characterFinished != nil) {
            [self removeChild:_characterFinished];
        }
        
        //choose which level success to display
        if ([_currentLevel.levelType isEqualToString:@"1player"]){
            if (isBestTime){
                [self displayOverlayScreen:@"Overlays/Overlay_Success_Best" withTime:_levelTimer];
            }
            else{
                [self displayOverlayScreen:@"Overlays/Overlay_Success" withTime:_levelTimer];
            }
        }
        else if ([_currentLevel.levelType isEqualToString:@"1playerRight"]){
            if (isBestTime){
                [self displayOverlayScreen:@"Overlays/Overlay_Success_Best"withTime:_levelTimer];
            }
            else{
                [self displayOverlayScreen:@"Overlays/Overlay_Success" withTime:_levelTimer];
            }
        }
        else{
            if (isBestTime){
                [self displayOverlayScreen:@"Overlays/Overlay_Success_Best" withTime:_levelTimer];
            }
            else{
                [self displayOverlayScreen:@"Overlays/Overlay_Success" withTime:_levelTimer];
            }
        }
        [UserData setLastLevelPlayed:++[GameState sharedInstance].currentLevelNumber];   
    }
}

//Auxilary method which compares the current time and best recorded time. returns true if current time is better than best time i.e. current time is best time
-(BOOL) isBestTimeOnLevel:(NSInteger)currentLevel {
    CGFloat currentHighScore = [UserData getHighScoreForLevel:currentLevel];
    if ((int)currentHighScore == 0 || currentHighScore > _levelTimer){
        [UserData setHighScoreForLevel:[GameState sharedInstance].currentLevelNumber withTime:_levelTimer];
        return YES;
    }
    return NO;
}

#pragma mark Collision Detection - Obstacles

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character face_obstacle:(CCSprite *)nodeB {
    if (![GameState sharedInstance].isGhostPowerupActive) {
        return [self collisionProtocolForCharacter:character withObstacle:nodeB withFaceReplacement:@"Resources/Miscellaneous/face-03.png"];
    }
    return false;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)character obstacle:(CCSprite *)nodeB {
    if(![GameState sharedInstance].isGhostPowerupActive){
        return [self collisionProtocolForCharacter:character withObstacle:nodeB withFaceReplacement:nil];
    }
    return NO;
}

-(BOOL) collisionProtocolForCharacter:(Character*)character withObstacle:(CCSprite*)obstacle withFaceReplacement:(NSString*)imageName{
    BOOL isValidCollision = [self isCollisionValidByCharacter:character];
    if (isValidCollision){
        if(imageName){
            ((CCSprite*)obstacle.children[0]).spriteFrame = [CCSpriteFrame frameWithImageNamed:imageName]; 
        }
        NSString *failMessage = [NSString stringWithFormat:@"%@ hit an obstacle.", character.characterName];
        [self gameOverwithMessage:failMessage];
        return isValidCollision;
    }
    return isValidCollision;
}

//Checks if character is in gameplay bounds, if character in bounds and hits obstacle, game over. If character out of bounds and hits obstacle, do nothing. 
- (BOOL) isCollisionValidByCharacter:(Character*)character{
    if (CGRectIntersectsRect(_currentLevel.boundingBox,character.boundingBox))
    {
        return YES;
    }
    return NO;
}

#pragma mark Pop-ups

//pause method (pause button selector)
-(void) pause {    
    CCLOG(@"Pause Pressed");
    if (isPhysicsNodePaused == NO){
        
        isPhysicsNodePaused = YES;
        if (_leftCharacter){
            _leftCharacter.paused = YES;
        }
        
        if (_rightCharacter) {
            _rightCharacter.paused = YES;
        }
        _pauseButton.visible = NO;
        _retryButton.visible = NO;
        _powerupButton.visible = NO;
        
        for(CCNode* powerupButton in _powerupSelect.children){
            powerupButton.visible = NO;
        }
        
        overlayScreen = [CCBReader loadAsScene:@"Overlays/Overlay_Pause" owner:self];
        [self addChild:overlayScreen];
    }
}

//resumes game (1 of 3 button selectors in pause menu; the other 2 are in overlay class)
-(void) resumeGame {
    CCLOG(@"Resume Pressed");
    isPhysicsNodePaused = NO;
    if (_leftCharacter){
        _leftCharacter.paused = NO;
    }
    
    if (_rightCharacter) {
        _rightCharacter.paused = NO;
    }
    _pauseButton.visible = YES;
    _retryButton.visible = YES;
    _powerupButton.visible = YES;
    
    for(CCNode* powerupButton in _powerupSelect.children){
        powerupButton.visible = YES;
    }

    [self removeChild:overlayScreen];  
    
}

-(void) retry {
    CCLOG(@"Retry Pressed");
    if (isPhysicsNodePaused == NO){
        [LoadScene gameplay];
    }
}

# pragma mark Powerups
-(void) powerup {    
    if (![GameState sharedInstance].powerupIconsDisplayed){
        powerups = [CCBReader load:@"Powerups" owner:self]; 
        [self updatePowerupLabels];
        [self addChild:powerups];
        [GameState sharedInstance].powerupIconsDisplayed = YES;
    }
    else{
        [self movePowerUpIconDisplay];
    }
}

-(void) updatePowerupLabels {
    [self updatePowerupWithCodeConnection:_powerupFast andID:@"com.chrisorcutt.biplanes.powerups.fast"];
    [self updatePowerupWithCodeConnection:_powerupSlow andID:@"com.chrisorcutt.biplanes.powerups.slow"];
    [self updatePowerupWithCodeConnection:_powerupStop andID:@"com.chrisorcutt.biplanes.powerups.stopSpinners"];
    [self updatePowerupWithCodeConnection:_powerupGhost andID:@"com.chrisorcutt.biplanes.powerups.ghost"];
}

-(void) updatePowerupWithCodeConnection:(CCLabelTTF*)codeConnection andID:(NSString*)ID {
    codeConnection.string = [NSString stringWithFormat:@"%i", [UserData getQuantityForPowerup:ID]];
}

-(void) powerup_fast {
    CCLOG(@"fast Pressed");
    if ([UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.fast"] > 0 && ![GameState sharedInstance].isFastPowerupActive) {
        [GameState sharedInstance].isFastPowerupActive = YES;
        [GameState sharedInstance].isSlowPowerupActive = NO;
        [self powerUpSpeed:4 turningRadius:1];
        [UserData setQuantity:[UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.fast"]-1 forPowerup:@"com.chrisorcutt.biplanes.powerups.fast"];
        [self updatePowerupWithCodeConnection:_powerupFast andID:@"com.chrisorcutt.biplanes.powerups.fast"];
    }
}

-(void) powerup_slow {
    CCLOG(@"slow Pressed");
    if ([UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.slow"] > 0 && ![GameState sharedInstance].isSlowPowerupActive) {
        [GameState sharedInstance].isFastPowerupActive = NO;
        [GameState sharedInstance].isSlowPowerupActive = YES;
        [self powerUpSpeed:1.5 turningRadius:5];
        [UserData setQuantity:[UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.slow"]-1 forPowerup:@"com.chrisorcutt.biplanes.powerups.slow"];
        [self updatePowerupWithCodeConnection:_powerupSlow andID:@"com.chrisorcutt.biplanes.powerups.slow"];
    }
}

-(void) powerup_normal {
    CCLOG(@"normal Pressed");
        [self powerUpSpeed:2 turningRadius:4];
}

-(void) powerUpSpeed:(CGFloat)speed turningRadius:(CGFloat)turningRadius {
    if (_leftCharacter) {
        _leftCharacter.speed = speed;
        _leftCharacter.turningRadius = turningRadius;
    }
    
    if (_rightCharacter) {
        _rightCharacter.speed = speed;
        _rightCharacter.turningRadius = turningRadius;
    }
    [self movePowerUpIconDisplay];
}

-(void) powerup_stop {
    if ([UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.stopSpinners"] > 0 && ![GameState sharedInstance].isStopPowerupActive) {
        [GameState sharedInstance].isStopPowerupActive = YES;
        spinSpeed = noSpeed;
        [UserData setQuantity:[UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.stopSpinners"]-1 forPowerup:@"com.chrisorcutt.biplanes.powerups.stopSpinners"];
        [self updatePowerupWithCodeConnection:_powerupStop andID:@"com.chrisorcutt.biplanes.powerups.stopSpinners"];
        [self movePowerUpIconDisplay];
    }
}

-(void) powerup_ghost {
    
    if ([UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.ghost"] > 0 && ![GameState sharedInstance].isGhostPowerupActive) {
        [GameState sharedInstance].isGhostPowerupActive = YES;
        if (_leftCharacter) {
            _leftCharacter.physicsBody.sensor = YES;
            [(CCSprite*)_leftCharacter.children[0] setOpacity:0.7];     
        }
        if (_rightCharacter) {
            _rightCharacter.physicsBody.sensor = YES;
            [(CCSprite*)_rightCharacter.children[0] setOpacity:0.7];  
//            CGPoint position = _rightCharacter.positionInPoints;
//            CGFloat rotation = _rightCharacter.rotation;
//            [_physicsNode removeChild:_rightCharacter];
//            _rightCharacter = (Character*)[CCBReader load:@"Characters/MMnophy"];
//            _rightCharacter.positionInPoints = position;
//            _rightCharacter.rotation  = rotation;
//            [(CCSprite*)_rightCharacter.children[0] setOpacity:0.7];
//            [self addChild:_rightCharacter];
        }
        [UserData setQuantity:[UserData getQuantityForPowerup:@"com.chrisorcutt.biplanes.powerups.ghost"]-1 forPowerup:@"com.chrisorcutt.biplanes.powerups.ghost"];
        [self updatePowerupWithCodeConnection:_powerupGhost andID:@"com.chrisorcutt.biplanes.powerups.ghost"];
        [self movePowerUpIconDisplay];
    }
}

-(void) powerup_store {
    [LoadScene store];
}

-(void) movePowerUpIconDisplay {
    CCActionMoveTo *action = [CCActionMoveTo actionWithDuration:0.5 position:ccpSub(powerups.position,ccp(100,0))];
    [powerups runAction:action];
    [self scheduleOnce:@selector(removePowerUpIconDisplay)  delay:0.5f];
}

-(void) removePowerUpIconDisplay {
    [self removeChild:powerups];
    [GameState sharedInstance].powerupIconsDisplayed = NO;
}

#pragma mark Update (Positioning and Camera)

-(void)update:(CCTime)delta { 
    if (isPhysicsNodePaused == NO) 
    {
        _levelTimer += delta;
        numberOfTimesUpdateMethodCalled++;
        
        if (!_leftCharacter.paused){
            [self updateCharacter:_leftCharacter withTimeStep:delta];

        }
        if(!_rightCharacter.paused){
            [self updateCharacter:_rightCharacter withTimeStep:delta];
        }
        [self setCameraPosition];
        [self updateSpinningObstacles:CWSpinningObstacleNode withSpeed:spinSpeed];
        [self updateSpinningObstacles:CCWSpinningObstacleNode withSpeed:(-1*spinSpeed)];
    }
}

-(void) updateSpinningObstacles:(CCNode*)node withSpeed:(CGFloat)speed {
    if (node) {
        for (CCNode* obstacle in node.children){
//            for (CCNode* physics in  obstacle.children) {
//                if (physics.physicsBody.type == CCPhysicsBodyTypeStatic) {
//                    physics.physicsBody.type = CCPhysicsBodyTypeKinematic;
//                }
//            } 
            
            obstacle.rotation = obstacle.rotation + speed;
            CCLOG(@"obstacle.rotation: %f; speed: %f", obstacle.rotation, speed);
        }
    }
    
}

-(void) updateCharacter:(Character*)character withTimeStep:(CCTime)delta {
    if (character) {
        [self setPositionOfCharacter:character];
        [self checkBoundsOnCharacter:character withTimeStep:delta];
        if (fmod(numberOfTimesUpdateMethodCalled,7) == 0) {
            [self putSmokeTrail:character];
        }
        character.outOfBoundsCounter = character.outOfBoundsCounter - delta;
    }
}

- (void) putSmokeTrail:(Character*) character {
    if (!character.paused){
        [character putSmokeTrail];
    }
}


- (void) setPositionOfCharacter:(Character*)character {
    if (!character.paused){
        if (character.sidePressed)
            [character getNewPosition];
        else
            [character getCharPosition];
    }
}

- (void) setCameraPosition {
    //moving camera based on which character has finished
    BOOL onePlayerModeActive;
    if ([_currentLevel.levelType isEqualToString:@"1player"] || [_currentLevel.levelType isEqualToString:@"1playerRight"]){
        onePlayerModeActive = YES;
    }
    else {
        onePlayerModeActive = NO;
    }
    
    if (onePlayerModeActive && _leftCharacter) {
        _charactersCenter.positionInPoints = _leftCharacter.positionInPoints;
    }
    else if (onePlayerModeActive && _rightCharacter) {
        _charactersCenter.positionInPoints = _rightCharacter.positionInPoints;
    }
    else if (_leftCharacter.isFinished && !_rightCharacter.isFinished){
        if (!isCameraMoved){
            isCameraMoved = YES;
            [self displayCharacterFinishedMessage:@"Charlie Finished!"];
            [self moveCameraTo];
        }
        else if (_rightCharacter.positionInPoints.x >= _charactersCenter.positionInPoints.x || actionMoveTo.isDone) {
            _charactersCenter.positionInPoints = _rightCharacter.positionInPoints;
        }
    }
    else if (!_leftCharacter.isFinished && _rightCharacter.isFinished){
        if (!isCameraMoved){
            isCameraMoved = YES;
            [self displayCharacterFinishedMessage:@"Marlie Finished!"];
            [self moveCameraTo];
        }
        else if (_leftCharacter.positionInPoints.x >= _charactersCenter.positionInPoints.x || actionMoveTo.isDone){
            _charactersCenter.positionInPoints = _leftCharacter.positionInPoints;
        }
    }
    else {
        [self calculateCenter];
    }
}

- (void) moveCameraTo{
    actionMoveTo = [CCActionMoveTo actionWithDuration:2.f position:ccp(0,0)];
    [_charactersCenter runAction:actionMoveTo];
}

- (void) displayCharacterFinishedMessage:(NSString*)finishedMessage {
    CGFloat screenSize = [[CCDirector sharedDirector] viewSize].width;
    if (abs(_leftCharacter.positionInPoints.x-_rightCharacter.positionInPoints.x) > screenSize/1.2 && _currentLevel.contentSizeInPoints.width > screenSize) {
        _characterFinished = [CCBReader load:@"CharacterFinished" owner:self];
        _characterFinishedText.string = finishedMessage;
        [self addChild: _characterFinished];
    }
}


-(void) calculateCenter {
    CGFloat xPosChar1 = _leftCharacter.positionInPoints.x;
    CGFloat yPosChar1 = _leftCharacter.positionInPoints.y;
    CGFloat xPosChar2 = _rightCharacter.positionInPoints.x;
    CGFloat yPosChar2 = _rightCharacter.positionInPoints.y;
    
    CGFloat xCenter;
    CGFloat yCenter;
    
    if (xPosChar1 > xPosChar2)
        xCenter = xPosChar2 + (xPosChar1 - xPosChar2)/2; 
    else
        xCenter = xPosChar1 + (xPosChar2 - xPosChar1)/2;
    
    if (yPosChar1 > yPosChar2)
        yCenter = yPosChar2 + (yPosChar1 - yPosChar2)/2;
    else
        yCenter = yPosChar1 + (yPosChar2 - yPosChar1)/2;
    
    _charactersCenter.positionInPoints = ccp(xCenter, yCenter);
}


//- (void) checkBoundsOnCharacter:(Character*)character withTimeStep:(CGFloat)delta {
//    
//    CCNode *dropDown;

//    
//    if (!character.isFinished && (character.positionInPoints.x > percievedWidthOfScreen || character.positionInPoints.x < percievedPositionOfScreen.x ||character.positionInPoints.y > percievedHeightOfScreen || character.positionInPoints.y < percievedPositionOfScreen.y))
//  {
//        CCLabelTTF *dropDownTimer;
//        NSString *dropDownName;
//        
//        character.outOfBoundsCounter += delta;
//        if ([character.characterName isEqualToString:@"Charlie"]) {
//            dropDownTimer = _dropDownChar1;
//            dropDownName = @"DropDown_Char1";
//        }
//        else {
//            dropDownTimer = _dropDownChar2;
//            dropDownName = @"DropDown_Char2";
//        }
//        dropDownTimer.string = [NSString stringWithFormat:@"%.2f", (4.1f-character.outOfBoundsCounter)];
//        
//        if (!character.outOfBoundsMessageDisplayed)
//        {
//            [self displayDropDownForCharacter:character withDropDown:dropDown withName:dropDownName];
//        }
//        
//        if (character.outOfBoundsCounter >= 4.1f && character.outOfBoundsMessageDisplayed){
//            [self gameOverByCharacter:character];
//        }
//    }
//    else {
//        [self characterInBounds:character removeDropDown:dropDown];
//    }
//}


/* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */

# pragma mark Out Of Bounds Arrow


- (void) checkBoundsOnCharacter:(Character*)character withTimeStep:(CGFloat)delta {
    /* Because I have levels longer than the screen size, I have to adjust to the coordinates of the viewable region of the screen to ensure that the out of bounds detection for characters works properly*/
    
    CGPoint screenOrigin = [self convertToWorldSpace:ccp(0,0)];
    CGPoint relativeScreenOrigin = [_physicsNode convertToNodeSpace:screenOrigin];
    
    CGSize screenSize = [[CCDirector sharedDirector] viewSize]; 
    CGFloat percievedWidthOfScreen = relativeScreenOrigin.x + screenSize.width;
    CGFloat percievedHeightOfScreen = screenSize.height;

    
    
    CGRect viewableScreenBoundingBox = CGRectMake(relativeScreenOrigin.x, relativeScreenOrigin.y, screenSize.width, screenSize.height);

    
    CGPoint worldPoint = [_physicsNode convertToWorldSpace:character.positionInPoints];
    CGPoint arrowPosition = [self convertToNodeSpace:worldPoint];

    
    if (character.positionInPoints.x < relativeScreenOrigin.x)
    {
        [self displayArrowForCharacter:character withXPosition:relativeScreenOrigin.x + 15 withYPosition:arrowPosition.y];
    }
    else if (!character.isFinished && character.positionInPoints.x > percievedWidthOfScreen) {
        [self displayArrowForCharacter:character withXPosition:percievedWidthOfScreen - 15 withYPosition:arrowPosition.y];
    }
    else if (character.positionInPoints.y > percievedHeightOfScreen) {
        [self displayArrowForCharacter:character withXPosition:arrowPosition.x withYPosition:percievedHeightOfScreen - 15 ];
    }
    else if (character.positionInPoints.y < relativeScreenOrigin.y) {
        [self displayArrowForCharacter:character withXPosition:arrowPosition.x withYPosition:relativeScreenOrigin.y + 15 ];
    }
    else {
        [self removeOutOfBoundsArrowForCharacter:character];
        character.outOfBoundsCounter = 4.0;
        character.blinkSlowAnimationPlayed = NO;
        character.blinkFastAnimationPlayed = NO;
        character.blinkReallyFastAnimationPlayed = NO;
    }
    
    if (character.outOfBoundsCounter <= 0) {
        [self gameOverByCharacter:character];
    }
}





/* -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
-(void) removeOutOfBoundsArrowForCharacter:(Character*) character {
    if (character.isLeftCharacter){
        if (OutOfBoundsArrow_Yellow){
            OutOfBoundsArrow_Yellow.visible = NO;
            [self removeChild:OutOfBoundsArrow_Yellow];
            OutOfBoundsArrow_Yellow = nil;
        }
    }
    else {
        if (OutOfBoundsArrow_Blue){
            OutOfBoundsArrow_Blue.visible = NO;
            [self removeChild:OutOfBoundsArrow_Blue];
            OutOfBoundsArrow_Blue = nil;
        }
    }
}

-(CCNode*) getOutOfBoundsArrowForCharacter:(Character*)character {
    CCNode* OutOfBoundsArrow;
    if (character.isLeftCharacter){
            OutOfBoundsArrow = OutOfBoundsArrow_Yellow;
    }
    else {
        OutOfBoundsArrow = OutOfBoundsArrow_Blue;
    }
    return OutOfBoundsArrow;
}

-(NSString*) getCCBFileNameForCharacter:(Character*)character {
    NSString* CCBFileName;
    if (character.isLeftCharacter){
        CCBFileName = @"OutOfBoundsArrow_Yellow";
    }
    else {
        CCBFileName = @"OutOfBoundsArrow_Blue";
    }
    return CCBFileName;
}

-(void) displayArrowForCharacter:(Character*)character withXPosition:(CGFloat)xPos withYPosition:(CGFloat)yPos {
    CCNode* OutOfBoundsArrow = [self getOutOfBoundsArrowForCharacter:character];
    NSString* CCBFileName = [self getCCBFileNameForCharacter:character];

    if (!OutOfBoundsArrow) {
        OutOfBoundsArrow = [CCBReader load:CCBFileName owner:self];
        [self addChild:OutOfBoundsArrow];
    }
    
    OutOfBoundsArrow.rotation = character.rotation;
    OutOfBoundsArrow.positionInPoints = ccp(xPos, yPos);
    
    if (character.outOfBoundsCounter <= 3.5 && !character.blinkSlowAnimationPlayed) {
        [OutOfBoundsArrow.animationManager runAnimationsForSequenceNamed:@"blink_slow"];
        character.blinkSlowAnimationPlayed = YES;
    }
    else if (character.outOfBoundsCounter <= 2.23 && !character.blinkFastAnimationPlayed) {
        [OutOfBoundsArrow.animationManager runAnimationsForSequenceNamed:@"blink_fast"];
        character.blinkFastAnimationPlayed = YES;
    }
    else if (character.outOfBoundsCounter <= 1.23 && !character.blinkReallyFastAnimationPlayed) {
        [OutOfBoundsArrow.animationManager runAnimationsForSequenceNamed:@"blink_reallyFast"];
        character.blinkReallyFastAnimationPlayed = YES;
    }
}





//-(void) characterInBounds:(Character*)character removeDropDown:(CCNode*)dropDown{
//    character.outOfBoundsCounter = 0;
//    if (character.outOfBoundsMessageDisplayed) {
//        [self removeDropDownForCharacter:character withDropDown:dropDown];
//    }
//}

//-(void) removeDropDownForCharacter:(Character*)character withDropDown:(CCNode*)dropDown {
//    dropDown = [self getDropDownAttributesForCharacter:character];
//    [self removeChild:dropDown];
//    dropDown = nil;
//    character.outOfBoundsMessageDisplayed = NO;
//}

//-(void) displayDropDownForCharacter:(Character*)character withDropDown:(CCNode*)dropDown withName:(NSString*)dropDownName {
//    dropDown = [CCBReader load:dropDownName owner:self];
//    [self addChild:dropDown];
//    character.outOfBoundsMessageDisplayed = YES;
//    [self setDropDownAttributesForCharacter:character withDropDown:dropDown];
//}

//-(CCNode*) getDropDownAttributesForCharacter:(Character*)character {
//    CCNode *dropDown;
//    if ([character.characterName isEqualToString:@"Charlie"]) {
//        dropDown = dropDown_Char1;
//    } 
//    else {
//        dropDown = dropDown_Char2;
//    }
//    return dropDown;
//}

//-(void) setDropDownAttributesForCharacter:(Character*)character withDropDown:(CCNode*)dropDown{
//    if ([character.characterName isEqualToString:@"Charlie"]) {
//        dropDown_Char1 = dropDown;
//    } 
//    else {
//        dropDown_Char2 = dropDown;
//    }
//}

#pragma mark Touch Handling

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    CGFloat halfScreenSize = [[CCDirector sharedDirector] viewSize].width/2;  
    
    if (touchLocation.x < halfScreenSize)    
    {
        leftTouch = touch;
        _leftCharacter.sidePressed = YES;
    }
    else 
    {
        rightTouch = touch;
        _rightCharacter.sidePressed = YES;
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    return;
}


-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (touch == leftTouch)
        _leftCharacter.sidePressed = NO; 
    else
        _rightCharacter.sidePressed = NO;
}

#pragma mark Auxilary

// Overlay screen loading mechanism; overlayType is passed via collision handlers and tutorial methods
- (void) displayOverlayScreen:(NSString*)overlayType {
    [self displayOverlayScreen:overlayType withMessage:nil withTime:nil];
}

- (void) displayOverlayScreen:(NSString*)overlayType withTime:(CGFloat)time {
    NSString *finishTime = [NSString stringWithFormat:@"%.2fs",time];
    [self displayOverlayScreen:overlayType withMessage:nil withTime:finishTime];
}

-(void) displayOverlayScreen:(NSString*)overlayType withMessage:(NSString*)overlayMessage{
    [self displayOverlayScreen:(NSString*)overlayType withMessage:(NSString*)overlayMessage withTime:nil];
}
       
- (void) displayOverlayScreen:(NSString*)overlayType withMessage:(NSString*)overlayMessage withTime:(NSString*)time{
    _physicsNode.paused = YES;
    isPhysicsNodePaused = YES;
    
    _pauseButton.visible = NO;
    _retryButton.visible = NO;
    _powerupButton.visible = NO;
    
    for(CCNode* powerupButton in _powerupSelect.children){
        powerupButton.visible = NO;
    }
    
    overlayScreen = [CCBReader load:overlayType owner:self];
    message.string = overlayMessage;
    _levelCompleteTime.string = time;
    NSString *bestTime = [NSString stringWithFormat:@"%.2fs",[UserData getHighScoreForLevel:[GameState sharedInstance].currentLevelNumber]];
    _levelCompleteBestTime.string = bestTime;
   [self addChild:overlayScreen];
}

- (void) gameOverByCharacter:(Character*)character{
    if(OutOfBoundsArrow_Yellow){
        [self removeOutOfBoundsArrowForCharacter:_leftCharacter];
    }
    if(OutOfBoundsArrow_Blue){
        [self removeOutOfBoundsArrowForCharacter:_rightCharacter];
    }
    
    
    NSString* outOfBoundMessage = [NSString stringWithFormat:@"%@ was out of bounds too long.", character.characterName];
    [self gameOverwithMessage:outOfBoundMessage];
}

- (void) gameOverwithMessage:(NSString*)gameoverMessage {
    [Analytics gameOverWithTime:_levelTimer withMessage:gameoverMessage];
    [self displayOverlayScreen:@"Overlays/Overlay_Fail" withMessage:gameoverMessage];
}

#pragma mark High Score/Sharing
- (void) shareButtonPressed {
    
    CCScene *scene = [[CCDirector sharedDirector] runningScene];
    CCNode *n = [scene.children objectAtIndex:0];
    UIImage *img = [self screenshotWithStartNode:n];
    
    NSString *shareText = [NSString stringWithFormat:@"New high score on level %li!\nThink you can beat it?\nhttps://itunes.apple.com/us/app/biplanes!/id904104087?ls=1&mt=8",(long)[GameState sharedInstance].currentLevelNumber];
    NSArray *itemsToShare = @[img, shareText];
    
    NSArray *excludedActivities = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    controller.excludedActivityTypes = excludedActivities;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
}

-(UIImage*) screenshotWithStartNode:(CCNode*)startNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize viewSize = [CCDirector sharedDirector].viewSize;
    CCRenderTexture* rtx = [CCRenderTexture renderTextureWithWidth:viewSize.width height:viewSize.height];
    [rtx begin];
    [startNode visit];
    [rtx end];
    
    return [rtx getUIImage];
}




@end

