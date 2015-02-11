//
//  TicketsViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 11/12/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import "TicketsViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "GetTicketsWebOperation.h"
#import "WebOperations.h"
#import "TicketsTableViewCell.h"
#import "Ticket.h"
#import "NSString+Utils.h"
#import "TicketInDetailsViewController.h"
#import "AddTicketViewController.h"
#import "UGHDataAccess.h"

typedef enum : NSUInteger {
    TicketTypeAll = 0,
    TicketTypeOpen,
    TicketTypeClosed,
} TicketType;


@interface TicketsViewController ()<WebOperationDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *ticketTypeSelectSegmant;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) GetTicketsWebOperation *getTicketsWebOperation;
@property (nonatomic, strong) NSMutableArray *ticketsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)segmentValueChanged:(id)sender;
- (IBAction)searchTapped:(id)sender;

@end

@implementation TicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Tickets";
    [self setUpInitialElements];
}

- (void)setUpInitialElements {
    [self homebutton];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self fetchTicketsDetailsForSubject:@"" andStatusId:[self statusIdForIndex:TicketTypeOpen]];
    [self.ticketTypeSelectSegmant setSelectedSegmentIndex:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TicketsTableViewCellIdentifier"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTicket)];
}
#pragma mark NetworkOperations
- (void)fetchTicketsDetailsForSubject:(NSString *)subject andStatusId:(NSString *)statusId {
    UGHDataAccess *dataAccess = [UGHDataAccess sharedDataAccess];
    if (!dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.getTicketsWebOperation) {
        return; // web op already in progess
    }
    self.getTicketsWebOperation = [[GetTicketsWebOperation alloc] initWithDelegate:self];
    self.getTicketsWebOperation.subject = subject;
    self.getTicketsWebOperation.statusId = statusId;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.getTicketsWebOperation];
}

#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    self.getTicketsWebOperation = nil;
    NSMutableArray *response = ((GetTicketsWebOperation *)webOp).responseArray;
    if (self.ticketsArray) {
        [self.ticketsArray removeAllObjects];
    }
    self.ticketsArray = [self ticketsForResponseArray:response];
    [self.tableView reloadData];
}

- (NSMutableArray *)ticketsForResponseArray:(NSArray *)array {
    if (!array) return nil;
    NSMutableArray *tempArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Ticket *ticket = [Ticket ticketFromDictionary:(NSDictionary *)obj];
        [tempArray addObject:ticket];
    }];
    return tempArray;
}

#pragma mark tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ticketsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsTableViewCellIdentifier"];
    [cell configureTicketCellWithTicket:(Ticket *)self.ticketsArray[indexPath.row]];
    return cell;
}

#pragma mark tableview Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TicketInDetailsViewController *ticketDetail = [[TicketInDetailsViewController alloc] initWithNibName:@"TicketInDetailsViewController" bundle:nil];
    ticketDetail.ticket = self.ticketsArray [indexPath.row];
    ticketDetail.title = ((Ticket *)self.ticketsArray [indexPath.row]).subject;
    [self.navigationController pushViewController:ticketDetail animated:YES];
}

#pragma mark  Actions
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    NSUInteger selectedSegment = sender.selectedSegmentIndex;
    [self fetchTicketsDetailsForSubject:@"" andStatusId:[self statusIdForIndex:selectedSegment]];
}

- (IBAction)searchTapped:(id)sender {
    [self fetchTicketsDetailsForSubject:[self.searchTextField.text stringByTrimmingWhitespaces] andStatusId:[self statusIdForIndex:self.ticketTypeSelectSegmant.selectedSegmentIndex]];
}

- (void)addTicket {
    AddTicketViewController *addTicketVc = [[AddTicketViewController alloc] initWithNibName:@"AddTicketViewController" bundle:nil];
    [self.navigationController pushViewController:addTicketVc animated:YES];
}
#pragma mark TextFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.searchTextField && !self.searchTextField.text.length) {
        [self fetchTicketsDetailsForSubject:@"" andStatusId:[self statusIdForIndex:TicketTypeOpen]];
        [self.ticketTypeSelectSegmant setSelectedSegmentIndex:1];
    }
}

#pragma mark Touch methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark Misc
- (NSString *)statusIdForIndex:(NSUInteger)index {
    switch (index) {
        case TicketTypeAll:
            return @"0";
            break;
        case TicketTypeOpen:
            return @"1";
            break;
        case TicketTypeClosed:
            return @"5";
            break;
        default:
            return nil;
            break;
    }
}
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
@end
/*
 //    switch (selectedSegment) {
 //        case TicketTypeAll:
 //            [self fetchTicketsDetailsForSubject:@"" andStatusId:@"0"];
 //            break;
 //        case TicketTypeOpen:
 //            [self fetchTicketsDetailsForSubject:@"" andStatusId:@"1"];
 //            break;
 //        case TicketTypeClosed:
 //            [self fetchTicketsDetailsForSubject:@"" andStatusId:@"5"];
 //            break;
 //        default:
 //            break;
 //    }*/