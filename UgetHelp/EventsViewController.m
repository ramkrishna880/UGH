//
//  EventsViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 10/12/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import "EventsViewController.h"
#import "SWRevealViewController.h"
#import "WebOperations.h"
#import "Event.h"
#import "UGHDataAccess.h"
#import "EventsTableViewCell.h"
#import "NSString+Utils.h"
#import "NoticesInDetailViewController.h"

@interface EventsViewController ()<WebOperationDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) EventsWebOperation *eventsWebOp;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) UGHDataAccess *dataAccess;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)searchEventTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialElements];
}

- (void)setUpInitialElements {
    self.title = @"Events";
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    [self homebutton];
    [self retriveAllEventsForName:@""];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.tableView registerNib:[UINib nibWithNibName:@"EventsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"EventsTableCellIdentifier"];
}
- (void)retriveAllEventsForName:(NSString *)name {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.eventsWebOp) {
        return; // web op already in progess
    }
    self.eventsWebOp = [[EventsWebOperation alloc] initWithDelegate:self];
    self.eventsWebOp.societyId = self.dataAccess.societyId;
    self.eventsWebOp.name = name;
    self.eventsWebOp.userId = self.dataAccess.userId;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.eventsWebOp];
}

#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    self.eventsWebOp = nil;
    id response = ((EventsWebOperation *)webOp).responseArray;
    self.events = [self eventsForResponseArray:response];
    [self.tableView reloadData];
}

- (NSMutableArray *)eventsForResponseArray:(NSArray *)array {
    if (!array) return nil;
    NSMutableArray *tempArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Event *event = [Event eventFromDictionary:(NSDictionary *)obj];
        [tempArray addObject:event];
    }];
    return tempArray;
}

#pragma Mark Misc
-(void)homebutton
{
    SWRevealViewController *revealController = [self revealViewController];
    UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeImage = [UIImage imageNamed:@"menu.png"];
    [home setBackgroundImage:homeImage forState:UIControlStateNormal];
    [home addTarget:revealController action:@selector(revealToggle:)
   forControlEvents:UIControlEventTouchUpInside];
    home.frame = CGRectMake(0, 0, 30, 20);
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:home];
    [[self navigationItem] setLeftBarButtonItem:button2];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}

#pragma mark TableView Datasource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EventsTableCellIdentifier"];
    [cell configureCellwithEvent:(Event *)self.events[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NoticesInDetailViewController *noticeIndetailVc = [[NoticesInDetailViewController alloc] initWithNibName:@"NoticesInDetailViewController" bundle:nil];
    noticeIndetailVc.isNotice = NO;
    noticeIndetailVc.obj = self.events[indexPath.row];
    noticeIndetailVc.title = ((Event *)self.events[indexPath.row]).name;
    [self.navigationController pushViewController:noticeIndetailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button Actions
- (IBAction)searchEventTapped:(id)sender {
    [self retriveAllEventsForName:[self.searchTextField.text stringByTrimmingWhitespaces]];
}

#pragma mark TextFielDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
