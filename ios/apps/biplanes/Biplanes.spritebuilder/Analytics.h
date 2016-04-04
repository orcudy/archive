//
//  Analytics.h
//  Biplanes!
//
//  Created by Orcudy on 7/20/14.
//  Copyright (c) 2014 Chris Orcutt All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Analytics : NSObject

+ (void)successWithTime:(CGFloat)time;
+ (void)gameOverWithTime:(CGFloat)time withMessage:(NSString*)message;
+ (void)gaveUpOnLevel;
+ (void)clickTime:(CGFloat)time atTutorial:(NSString*)tutorial;
//TODO -- analytics for different tutorial presentation


@end
