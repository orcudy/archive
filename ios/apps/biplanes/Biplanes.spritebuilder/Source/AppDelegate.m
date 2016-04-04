 /*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"
#import "UserData.h"
#import "GameState.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    NSString* reminderMessage;
    int reminderNumber = arc4random_uniform(4) + 1;
    
    switch (reminderNumber) {
        case 1:
            reminderMessage = @"Let's go flying! - Charlie & Marlie";
            break;
        case 2:
            reminderMessage = @"Ready for lift off! - Marlie";
            break;
        case 3:
            reminderMessage = @"How about a quick flight? - Charlie";
            break;
        case 4:
            reminderMessage = @"We're ready to soar! - Charlie & Marlie";
            break;
        default:
            reminderMessage = @"Let's go flying! - Charlie & Marlie";
            break;
    }
    
    [MGWU loadMGWU:@"3hg1rw4hp2gh7wr1ph"];
    [MGWU setReminderMessage:reminderMessage];
    [MGWU setAppiraterAppId:@"904104087" andAppName:@"Biplanes!"];
    [MGWU preFacebook];
    [Crashlytics startWithAPIKey:@"a4a9c584a1b292fcc75af7ffc1f3a4df70ca8450"];
    
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    [CCDirector sharedDirector].displayStats = NO;

    
    return YES;
}

- (CCScene*) startScene
{    
    if (![UserData getLastLevelPlayed]){
        [UserData setQuantity:100 forPowerup:@"com.chrisorcutt.biplanes.powerups.fast"];  
        [UserData setQuantity:100 forPowerup:@"com.chrisorcutt.biplanes.powerups.slow"]; 
        [UserData setQuantity:100 forPowerup:@"com.chrisorcutt.biplanes.powerups.stopSpinners"]; 
        [UserData setQuantity:100 forPowerup:@"com.chrisorcutt.biplanes.powerups.ghost"]; 
        
        [GameState sharedInstance].mode = @"story";
        return [CCBReader loadAsScene:@"Scenes/Scene_Gameplay_Tutorial"];
    }
    else {
        [GameState sharedInstance].currentLevelNumber = [UserData getLastLevelPlayed];  
        return [CCBReader loadAsScene:@"Scenes/Scene_MainScene"];
    }
}

@end
