//
//  Level.h
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode

@property (nonatomic,assign) CGFloat goldTime;
@property (nonatomic,assign) CGFloat silverTime;
@property (nonatomic, assign) BOOL delayCharacterMovement;
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, copy) NSString *levelType;
@property (nonatomic, copy) NSString *tutorialMessage;

@end
