//
//  UIColor+Theme.h
//  eWeek
//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Theme)

+ (UIColor *)applicationGreenTheme;
+ (UIColor *)applicationYellowTheme;
+ (UIColor *)applicationBlueTheme;
+ (UIColor *)applicationOrangeTheme;
+ (NSUInteger)numberOfApplicationThemes;

+ (UIColor *)applicationGreenThemeSecondary;
+ (UIColor *)applicationYellowThemeSecondary;
+ (UIColor *)applicationBlueThemeSecondary;
+ (UIColor *)applicationOrangeThemeSecondary;

+ (UIColor *)applicationForegroundLightGray;
+ (UIColor *)applicationForegroundDarkGray;
+ (UIColor *)applicationBackgroundGray;

@end
