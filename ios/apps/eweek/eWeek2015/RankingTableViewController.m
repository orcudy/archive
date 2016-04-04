//
//  RankingTableViewController.m
//  eWeek
//
//  Created by Christopher Orcutt on 2/21/15.
//  Copyright (c) 2015 Christopher Orcutt. All rights reserved.
//

#import "RankingTableViewController.h"
#import "RankingDataModel.h"
#import "RankingDetailTableViewController.h"
#import "ScrollToRefresh.h"
#import "Globals.h"
#import "Team.h"

@interface RankingTableViewController ()
@property (nonatomic, strong) RankingDataModel *rankingDataModel;
@property (nonatomic, strong) ScrollToRefresh *refresher;

@end

@implementation RankingTableViewController

#pragma mark - Initialization

- (ScrollToRefresh *)refresher{
    if (!_refresher){
        _refresher = [[ScrollToRefresh alloc] init];
    }
    return _refresher;
}

- (RankingDataModel *)rankingDataModel{
    if (!_rankingDataModel){
        _rankingDataModel = [[RankingDataModel alloc] init];
    }
    return _rankingDataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refresher.parentController = self;
    [self.refresher setupScrollToRefresh];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Refresh

//- (void) setupScrollToRefresh
//{
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
//    [self setRefreshControl:refreshControl];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"updateRankingTableUI" object:nil];
//}
//
//- (void) refresh
//{
//    [self.refreshControl beginRefreshing];
//    [self.rankingDataModel refreshData];
//}
//
//- (void)updateUI{
//    [[Globals sharedInstance] changeApplicationColorTheme];
//    [self.tableView reloadData];
//    [self.refreshControl endRefreshing];
//
//}

#pragma mark - TableViewDataSourceProtocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rankingDataModel totalNumberOfTeams];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankingCell" forIndexPath:indexPath];
    
    Team * team = [self.rankingDataModel teamAtIndex:indexPath.row];
    
    UILabel *teamNameLabel = (UILabel *)[cell viewWithTag:1];
    teamNameLabel.text = team.name;
    teamNameLabel.textColor = [Globals sharedInstance].applicationColorForegroundLightGray;

    
    UILabel *totalPointsLabel = (UILabel *)[cell viewWithTag:2];
    totalPointsLabel.text = [NSString stringWithFormat:@"%li pts", (long)team.totalPoints];
    totalPointsLabel.textColor = [Globals sharedInstance].applicationColorForegroundDarkGray;
    
    return cell;
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DetailedRanking"]){
        RankingDetailTableViewController *rankingDetailViewController = [segue destinationViewController];
        rankingDetailViewController.teamName = ((UILabel *)[sender viewWithTag:1]).text;
    }
}

@end
