//
//  ScheduleTableViewController.m
//  Schedule
//
//  Created by Christopher Orcutt on 3/8/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "ScheduleRootViewController.h"
#import "ScheduleTableViewController.h"
#import "Event.h"
#import "Globals.h"
#import "ScrollToRefresh.h"

@interface ScheduleTableViewController ()

@property (nonatomic, strong) ScheduleDataModel *scheduleDataModel;
@property (nonatomic, strong) ScrollToRefresh *refresher;

@end

@implementation ScheduleTableViewController

- (ScrollToRefresh *)refresher{
    if (!_refresher){
        _refresher = [[ScrollToRefresh alloc] init];
    }
    return _refresher;
}

- (ScheduleDataModel *)scheduleDataModel{
    if (!_scheduleDataModel){
        _scheduleDataModel = [[ScheduleDataModel alloc] init];
    }
    return _scheduleDataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refresher.parentController = self;
    [self.refresher setupScrollToRefresh];
    self.events = [self.scheduleDataModel.eventScheduler eventsForDate:self.date];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *date = [dateFormatter stringFromDate:self.date];
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@",date];
}

- (void)refreshData{
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUI" object:nil];
}

#pragma mark - ScheduleTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell" forIndexPath:indexPath];
    
    UILabel *eventNameLabel = (UILabel *)[cell viewWithTag:1];
    eventNameLabel.text = ((Event *)self.events[indexPath.row]).name;
    eventNameLabel.textColor = [Globals sharedInstance].applicationColorForegroundLightGray;
    
    NSString *startTime = ((Event *)self.events[indexPath.row]).startTime;
    NSString *endTime = ((Event *)self.events[indexPath.row]).endTime;
    
    UILabel *eventTimeLabel = (UILabel *)[cell viewWithTag:2];
    eventTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
    eventTimeLabel.textColor = [Globals sharedInstance].applicationColorForegroundDarkGray;
    
    UILabel *eventLocationLabel = (UILabel *)[cell viewWithTag:3];
    eventLocationLabel.text = ((Event *)self.events[indexPath.row]).locationName;
    eventLocationLabel.textColor = [Globals sharedInstance].applicationColorForegroundDarkGray;
    
    return cell;
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"scheduleDetailedViewController"]){
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        
//        NSUInteger index = [((ScheduleRootViewController *)self.parentViewController.parentViewController).scheduleDataModel indexOfViewController:self];
//        
//        ScheduleTableViewController *scheduleTableViewController = [((ScheduleRootViewController *)self.parentViewController.parentViewController).scheduleDataModel viewControllerAtIndex:index storyboard:self.parentViewController.parentViewController.storyboard];
//
//        ((ScheduleDetailViewController *)[segue destinationViewController]).eventDescription = ((Event *)scheduleTableViewController.events[indexPath.row]).eventDescription;
//    }
//}


@end
