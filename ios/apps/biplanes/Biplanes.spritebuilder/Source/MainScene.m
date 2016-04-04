//
//  MainScene.m
//  Biplanes!
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameState.h"
#import "UserData.h"
#import "LoadScene.h"


@implementation MainScene 

- (void) story { 
    CCLOG(@"story pressed");
    
    //If running for the first time, start at level 1
    if (![GameState sharedInstance].currentLevelNumber || [GameState sharedInstance].currentLevelNumber > 30) {
        [GameState sharedInstance].currentLevelNumber = 1;
        [UserData setLastLevelPlayed:1];
    }
    else {
        [GameState sharedInstance].currentLevelNumber = [UserData getLastLevelPlayed];  
    }
   
    [GameState sharedInstance].mode = @"story";
    [GameState sharedInstance].numberOfFails = 0; //analytics
    [LoadScene gameplay];
}

@end
