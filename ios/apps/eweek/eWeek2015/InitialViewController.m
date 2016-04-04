//
//  InitialViewController.m
//  eWeek_Ranking
//
//  Created by Christopher Orcutt on 3/10/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "InitialViewController.h"
#import "RankingTableViewController.h"
#import "Globals.h"

@interface InitialViewController ()

@property (nonatomic) BOOL applicationStarted;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.color = [Globals sharedInstance].applicationColorTheme;
    self.applicationStarted = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startApplication) name:@"updateData"  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startApplication{
    if (!self.applicationStarted){
        self.applicationStarted = YES;
        UITabBarController *tabBarController = (UITabBarController *)[self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        
        [self presentViewController:tabBarController animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
