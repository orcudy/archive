//
//  PointsTableViewController.m
//  eWeek
//
//  Created by Christopher Orcutt on 2/21/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//


#import "RankingDetailTableViewController.h"
#import "ScrollToRefresh.h"
#import "Globals.h"
#import "Event.h"

@interface RankingDetailTableViewController ()
@property (nonatomic, strong) RankingDetailDataModel *rankingDetailDataModel;
@property (nonatomic, strong) ScrollToRefresh *refresher;

@end

@implementation RankingDetailTableViewController

#pragma mark - Initialization

- (ScrollToRefresh *)refresher{
    if (!_refresher){
        _refresher = [[ScrollToRefresh alloc] init];
    }
    return _refresher;
}

- (RankingDetailDataModel *)rankingDetailDataModel{
    if (!_rankingDetailDataModel){
        _rankingDetailDataModel = [[RankingDetailDataModel alloc] init];
    }
    return _rankingDetailDataModel;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = self.teamName;
    self.view.backgroundColor = [Globals sharedInstance].applicationColorBackgroundGray;
    self.refresher.parentController = self;
    [self.refresher setupScrollToRefresh];
    self.rankingDetailDataModel.teamName = self.teamName;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.rankingDetailDataModel totalDates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDate *date = [self.rankingDetailDataModel dateAtIndex:section];
    return [[self.rankingDetailDataModel eventsForDate:date] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *date = [self.rankingDetailDataModel dateAtIndex:section];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [dateFormatter stringFromDate:date];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{

    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:((UIColor *)[Globals sharedInstance].applicationColorThemeSecondary)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingDetailCell" forIndexPath:indexPath];
    
    Event *event = [self.rankingDetailDataModel eventAtIndex:indexPath.row inSection:indexPath.section];
    
    NSInteger eventPoints = [self.rankingDetailDataModel pointsForEventWithName:event.name];
    
    UILabel *eventNameLabel = (UILabel *)[cell viewWithTag:1];
    eventNameLabel.text = event.name;
    eventNameLabel.textColor = [Globals sharedInstance].applicationColorForegroundLightGray;
    
    
    UILabel *teamNameLabel = (UILabel *)[cell viewWithTag:2];
    teamNameLabel.text = [NSString stringWithFormat:@"%ld pts", (long)eventPoints];
    teamNameLabel.textColor = [Globals sharedInstance].applicationColorForegroundDarkGray;

    return cell;
}

@end
