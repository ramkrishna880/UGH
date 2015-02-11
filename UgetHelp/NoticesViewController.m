//
//  NoticesViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "NoticesViewController.h"
#import "SWRevealViewController.h"
#import "WebOperations.h"
#import "Notice.h"
#import "UGHDataAccess.h"
#import "NoticeTableViewCell.h"
#import "NSString+Utils.h"
#import "NoticesInDetailViewController.h"

#define NoticeTableCellIdentifier @"NoticesTableCellIdentifier"
@interface NoticesViewController ()<WebOperationDelegate>
@property (nonatomic, strong) NoticesWebOperation *noticesWebOp;
@property (nonatomic, strong) NSMutableArray *notices;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UGHDataAccess *dataAccess;
- (IBAction)searchNoticeInfoTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@end

@implementation NoticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Notices";
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialElements];
    
}

- (void)setUpInitialElements {
    [self homebutton];
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    [self retriveAllNoticesforSearchText:@""];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NoticesTableCellIdentifier"];
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)retriveAllNoticesforSearchText:(NSString *)searchText {
    if (![self.dataAccess isConnected]) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.noticesWebOp) {
        return; // web op already in progess
    }
    self.noticesWebOp = [[NoticesWebOperation alloc] initWithDelegate:self];
    self.noticesWebOp.societyId = self.dataAccess.societyId;
    self.noticesWebOp.searchText = searchText;
    self.noticesWebOp.userId = self.dataAccess.userId;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.noticesWebOp];
}

#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    self.noticesWebOp = nil;
    id response = ((NoticesWebOperation *)webOp).responseArray;
    self.notices = [self noticesForResponseArray:response];
    [self.tableView reloadData];
}

- (NSMutableArray *)noticesForResponseArray:(NSArray *)array {
    if (!array) return nil;
    NSMutableArray *tempArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       Notice *notice = [Notice noticeFromDictionary:(NSDictionary *)obj];
        [tempArray addObject:notice];
    }];
    return tempArray;
}

#pragma  mark TableViewData source 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticesTableCellIdentifier"];
    [cell configureCellWithNoticeDetails:(Notice *)self.notices[indexPath.row]];
    return cell;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NoticesInDetailViewController *noticeIndetailVc = [[NoticesInDetailViewController alloc] initWithNibName:@"NoticesInDetailViewController" bundle:nil];
//    noticeIndetailVc.notice = self.notices[indexPath.row];
    noticeIndetailVc.isNotice = YES;
    noticeIndetailVc.obj = self.notices[indexPath.row];
    noticeIndetailVc.title = ((Notice *)self.notices[indexPath.row]).subject;
    [self.navigationController pushViewController:noticeIndetailVc animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)searchNoticeInfoTapped:(id)sender {
    [self retriveAllNoticesforSearchText:[self.searchTextField.text stringByRemovingWhitespaceCharacters]];
}
@end
