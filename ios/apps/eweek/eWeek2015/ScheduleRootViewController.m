//
//  ViewController.m
//  Schedule
//
//  Created by Christopher Orcutt on 3/7/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "ScheduleRootViewController.h"
#import "ScheduleDataModel.h"
#import "ScheduleTableViewController.h"

#import "EventScheduler.h"

#import "Globals.h"

@interface ScheduleRootViewController ()
@property (nonatomic, strong) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation ScheduleRootViewController

- (ScheduleDataModel *)scheduleDataModel{
    if (!_scheduleDataModel){
        _scheduleDataModel = [[ScheduleDataModel alloc] init];
    }
    return _scheduleDataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scheduleDataModel = [self scheduleDataModel];
    [self instantiatePageController];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundColor:[Globals sharedInstance].applicationColorTheme];
}

- (void)instantiatePageController{
    UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController = pageController;
    self.pageController.dataSource = self.scheduleDataModel;
    
    ScheduleTableViewController *scheduleTableViewController = [self.scheduleDataModel viewControllerAtIndex:0 storyboard:self.storyboard];
    [self.pageController setViewControllers:@[scheduleTableViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    }
    self.pageController.view.frame = pageViewRect;
    [self.pageController didMoveToParentViewController:self];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    self.view.gestureRecognizers = self.pageController.gestureRecognizers;
    [self.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
