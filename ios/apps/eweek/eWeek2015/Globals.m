//
//  Globals.m
//  ucla-engineering-week-2015
//
//  Created by Christopher Orcutt on 2/13/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "Globals.h"
#import "MasterData.h"
#import "UIColor+Theme.h"

@interface Globals()
@property (nonatomic) NSInteger applicationColorID;
@property (nonatomic) NSInteger nextApplicationColorID;

@end

@implementation Globals

#pragma mark - Initialization

- (MasterData *)masterData{
    if (!_masterData){
        _masterData = [[MasterData alloc] init];
    }
    return _masterData;
}

- (instancetype)init{
    self = [super init];
    if (self){
        self.headerFontName = @"OstrichSans-Medium";
        self.headerFontSize = 35.0f;
        
        self.nextApplicationColorID = [self chooseColorForID:self.nextApplicationColorID];
        self.nextApplicationColorTheme = [self getPrimaryColor:self.nextApplicationColorID];
        self.nextApplicationColorThemeSecondary = [self getSecondaryColor:self.nextApplicationColorID];
        
        self.applicationColorBackgroundGray = [UIColor applicationBackgroundGray];
        self.applicationColorForegroundDarkGray = [UIColor applicationForegroundDarkGray];
        self.applicationColorForegroundLightGray = [UIColor applicationForegroundLightGray];
    }
    return self;
}
#pragma mark - API

+ (Globals *)sharedInstance {
    static dispatch_once_t onceToken;
    static Globals *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Globals alloc] init];
    });
    return instance;
}

- (void)changeApplicationColorTheme{
    self.applicationColorID = self.nextApplicationColorID;
    self.applicationColorTheme = self.nextApplicationColorTheme;
    self.applicationColorThemeSecondary = self.nextApplicationColorThemeSecondary;

    self.nextApplicationColorID = [self chooseColorForID:self.nextApplicationColorID];
    self.nextApplicationColorTheme = [self getPrimaryColor:self.nextApplicationColorID];
    self.nextApplicationColorThemeSecondary = [self getSecondaryColor:self.nextApplicationColorID];
}

- (void)fetchMasterData{
    [self.masterData fetchData];
}

#pragma mark - Helper Methods

- (NSInteger)chooseColorForID:(NSInteger)ID {
    int randNum;
    while ((randNum = rand() % [UIColor numberOfApplicationThemes]) == ID);
    return randNum;
}

- (UIColor *)getPrimaryColor:(NSInteger)colorIndex{
    switch (colorIndex) {
        case 0:
            return [UIColor applicationOrangeTheme];
        case 1:
            return [UIColor applicationBlueTheme];
        case 2:
            return [UIColor applicationYellowTheme];
        case 3:
            return [UIColor applicationGreenTheme];
        default:
            return nil;
    }
}

- (UIColor *)getSecondaryColor:(NSInteger)colorIndex{
    switch (colorIndex) {
        case 0:
            return [UIColor applicationOrangeThemeSecondary];
        case 1:
            return [UIColor applicationBlueThemeSecondary];
        case 2:
            return [UIColor applicationYellowThemeSecondary];
        case 3:
            return [UIColor applicationGreenThemeSecondary];
        default:
            return nil;
    }
}

@end
