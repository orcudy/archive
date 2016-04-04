//
//  LevelSelect.m
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import "LevelSelect.h"
#import "Gameplay.h"
#import "GameState.h"
#import "UserData.h"
#import "Analytics.h"
#import "LoadScene.h"

@implementation LevelSelect {
    CCNode* _menuTileNode;
}

-(void) didLoadFromCCB {
    [Analytics gaveUpOnLevel];
    
    for(NSInteger i = 0; i <= 29; i++) {
        BOOL isLevelComplete = [UserData getStatusOfLevel:(i+1)];
        
        if (isLevelComplete){
            CCNode* star = [CCBReader load:@"star"];
            star.position = ccp(0, 35);
            [_menuTileNode.children[i] addChild:star];
        }
    }
}

- (void) level:(NSInteger)index {
    [GameState sharedInstance].numberOfFails = 0; //Analytics
    [GameState sharedInstance].currentLevelNumber = index;
    [UserData setLastLevelPlayed:index];
    [LoadScene gameplay];
}

- (void) Level1 {
    [self level:1];
}

- (void) Level2 {
    [self level:2];
}

- (void) Level3 {
    [self level:3];
}

- (void) Level4 {
    [self level:4];
}

- (void) Level5 {
    [self level:5];
}

- (void) Level6 {
   [self level:6];
}

- (void) Level7 {
    [self level:7];
}

- (void) Level8 {
    [self level:8];
}

- (void) Level9 {
    [self level:9];
}

- (void) Level10 {
    [self level:10];
}

- (void) Level11 {
    [self level:11];
}

- (void) Level12 {
    [self level:12];
}

- (void) Level13 {
    [self level:13];
}

- (void) Level14 {
    [self level:14];
}

- (void) Level15 {
    [self level:15];
}

- (void) Level16 {
    [self level:16];
}

- (void) Level17 {
    [self level:17];
}

- (void) Level18 {
    [self level:18];
}

- (void) Level19 {
    [self level:19];
}

- (void) Level20 {
    [self level:20];
}

- (void) Level21 {
    [self level:21];
}

- (void) Level22 {
    [self level:22];
}

- (void) Level23 {
    [self level:23];
}

- (void) Level24 {
    [self level:24];
}

- (void) Level25 {
    [self level:25];
}

- (void) Level26 {
    [self level:26];
}

- (void) Level27 {
    [self level:27];
}

- (void) Level28 {
    [self level:28];
}

- (void) Level29 {
    [self level:29];
}

- (void) Level30 {
    [self level:30];
}

@end
