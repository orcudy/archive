//
//  Gameplay_protected.h
//  Biplanes
//
//  Created by Chris Orcutt on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Character.h"
#import "Level.h"

@interface Gameplay()
/* -- -- -- -- -- -- Game Setting -- -- -- -- -- -- */
@property (nonatomic, strong) Level *loadedLevel;
//From SpriteBuilder
@property (nonatomic, strong) CCPhysicsNode *physicsNode;
@property (nonatomic, strong) Level *currentLevel;


/* -- -- -- Character Position and Checking -- -- -- */
//From SpriteBuilder
@property (nonatomic, strong) Character *leftCharacter;
@property (nonatomic, strong) Character *rightCharacter;
@property (nonatomic, strong) CCNode *charactersCenter;

/* -- -- -- -- -- -- Analytics variables -- -- -- -- -- -- */
@property (nonatomic, assign) CCTime levelTimer;  //keep for analytics 

-(void) retry; 
-(void) selectGameplaySettings;
-(void) didLoadFromCCB;


@end
