//
//  Globals.h
//  ucla-engineering-week-2015
//
//  Created by Christopher Orcutt on 2/13/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MasterData.h"


@interface Globals : NSObject

@property (nonatomic, strong) NSString *headerFontName;
@property (nonatomic) float headerFontSize;

@property (nonatomic, strong) UIColor *applicationColorForegroundLightGray;
@property (nonatomic, strong) UIColor *applicationColorForegroundDarkGray;
@property (nonatomic, strong) UIColor *applicationColorBackgroundGray;

@property (nonatomic, strong) UIColor *applicationColorTheme;
@property (nonatomic, strong) UIColor *applicationColorThemeSecondary;

@property (nonatomic, strong) UIColor *nextApplicationColorTheme;
@property (nonatomic, strong) UIColor *nextApplicationColorThemeSecondary;

@property (nonatomic, strong) MasterData *masterData;

+ (Globals *)sharedInstance;
- (void)changeApplicationColorTheme;
- (void)fetchMasterData;

@end
