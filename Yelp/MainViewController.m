//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessViewCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *resultsView;

- (void) refreshTableView:(NSString *) query params:(NSDictionary *) filters;

@property (nonatomic, strong) YelpClient *client;

@property (nonatomic, strong) NSArray *businesses;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self refreshTableView:@"Restaurants" params:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultsView.dataSource = self;
    self.resultsView.delegate = self;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    self.navigationItem.leftBarButtonItem = leftButton;
    //*searchBar = [[UISearchBar alloc] init];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    
    [self.resultsView registerNib:[UINib nibWithNibName:@"BusinessViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    self.resultsView.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view from its nib.
}

- (void) onFilterButton {
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void) filtersViewController:(FilterViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    NSLog(@"fired Event : %@", filters);
    [self refreshTableView:@"Restaurants" params:filters];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessViewCell *businessViewCell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    businessViewCell.business = self.businesses[indexPath.row];
    return businessViewCell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self refreshTableView:[NSString stringWithFormat:@"%@", searchText ] params:nil];
}

- (void) refreshTableView:(NSString *)query params:(NSDictionary *)filters {
        
    [self.client searchWithTerm:query params:filters success:^(AFHTTPRequestOperation *operation, id response)
      
        {
            NSLog(@"response: %@", response);
            NSArray *dictionary = response[@"businesses"];
            self.businesses = [Business initBusinesses:dictionary];
            
            [self.resultsView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
}

@end
