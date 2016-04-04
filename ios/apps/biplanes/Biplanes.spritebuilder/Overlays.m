//
//  Overlays.m
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import "Overlays.h"
#import "GameState.h"
#import "UserData.h"
#import "LoadScene.h"

@implementation Overlays
//Fail screen selector
-(void) retry {
    CCLOG(@"Replay Pressed");
    [LoadScene gameplay];
}

//Fail screen selector (also screen selector for pause)
- (void) levels {
    CCLOG(@"Replay Pressed");
    [LoadScene levelSelect];
}

//Success screen selector
-(void) nextLevel {
    CCLOG(@"Next Level Pressed");
    if ([GameState sharedInstance].currentLevelNumber == 31){
        [UserData setLastLevelPlayed:1];
        [GameState sharedInstance].currentLevelNumber = 1;
        [LoadScene completedLevel30];
    }
    else if ([GameState sharedInstance].currentLevelNumber == 11){
        [LoadScene gameplay_Tutorial];
    }
    else {
        [LoadScene gameplay];
    }
}

-(void) menu {
    CCLOG(@"Menu Pressed");
    [LoadScene menu];
}

@end
