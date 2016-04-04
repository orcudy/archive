//
//  LoadScene.m
//  Biplanes
//
//  Created by Chris Orcutt on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LoadScene.h"
#import "GameState.h"

@implementation LoadScene

+ (void) loadScene:(NSString*)scene withTransitionTime:(CCTime)time {
    CCScene *storeScene = [CCBReader loadAsScene:scene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:time];
    [[CCDirector sharedDirector] presentScene:storeScene withTransition:transition];
}

+ (void) gameplay{
    [self loadScene:@"Scenes/Scene_Gameplay" withTransitionTime:0.5];
}

+ (void) gameplay_Tutorial{
    [self loadScene:@"Scenes/Scene_Gameplay_Tutorial" withTransitionTime:2];
}

+ (void) store {
    CCScene *storeScene = [CCBReader loadAsScene:@"Scenes/Scene_Store"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:.5f];
    [[CCDirector sharedDirector] pushScene:storeScene withTransition:transition];
}

+ (void) menu {
    [self loadScene:@"Scenes/Scene_MainScene" withTransitionTime:0.5];
}

+ (void) levelSelect {
    [self loadScene:@"Scenes/Scene_Menu" withTransitionTime:0.5];
}

+ (void) completedLevel30 {
    [self loadScene:@"Scenes/Scene_GameCompleted" withTransitionTime:0.5];
}





@end
