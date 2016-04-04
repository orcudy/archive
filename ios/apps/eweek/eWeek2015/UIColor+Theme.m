//
//  UIColor+Theme.m
//  eWeek
//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "UIColor+Theme.h"


@implementation UIColor (Theme)

+ (float)foregroundLightGray{
    return 120;
}

+ (float)foregroundDarkGray{
    return 110;
}

+ (float)backgroundGray{
    return 240;
}

+ (float)alpha{
    return 0.6f;
}

+ (UIColor *) colorFromRed:(float)red Green:(float)green Blue:(float)blue withAlpha:(float)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)applicationGreenTheme {
    return [UIColor colorFromRed:20 Green:181 Blue:75 withAlpha:1];
}

+ (UIColor *)applicationYellowTheme {
    return[UIColor colorFromRed:247 Green:140 Blue:27 withAlpha:1];
}

+ (UIColor *)applicationBlueTheme {
    return [UIColor colorFromRed:22 Green:121 Blue:154 withAlpha:1];
}

+ (UIColor *)applicationOrangeTheme {
    return [UIColor colorFromRed:247 Green:61 Blue:27 withAlpha:1];
}

+ (UIColor *)applicationGreenThemeSecondary {
    return [UIColor colorFromRed:20 Green:181 Blue:75 withAlpha:[self alpha]];
}

+ (UIColor *)applicationYellowThemeSecondary {
    return[UIColor colorFromRed:247 Green:140 Blue:27 withAlpha:[self alpha]];
}

+ (UIColor *)applicationBlueThemeSecondary {
    return [UIColor colorFromRed:22 Green:121 Blue:154 withAlpha:[self alpha]];
}

+ (UIColor *)applicationOrangeThemeSecondary {
    return [UIColor colorFromRed:247 Green:61 Blue:27 withAlpha:[self alpha]];
}

+ (UIColor *)applicationForegroundLightGray {
    float color = [UIColor foregroundLightGray];
    return [UIColor colorFromRed:color Green:color Blue:color withAlpha:1];
}

+ (UIColor *)applicationForegroundDarkGray {
    float color = [UIColor foregroundDarkGray];
    return [UIColor colorFromRed:color Green:color Blue:color withAlpha:1];
}

+ (UIColor *)applicationBackgroundGray {
    float color = [UIColor backgroundGray];
    return [UIColor colorFromRed:color Green:color Blue:color withAlpha:1];
}

+ (NSUInteger)numberOfApplicationThemes{
    return 4;
}


@end
