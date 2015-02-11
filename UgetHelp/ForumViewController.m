//
//  ForumViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "ForumViewController.h"
#import "WebOperations.h"
#import "SWRevealViewController.h"
#import "Forum.h"
#import "User.h"
#import "GenericTableViewCell.h"
#import "UGHDataAccess.h"
#import "NSString+Utils.h"
#import "DetailForumViewController.h"
#import "AddForumViewController.h"

@interface ForumViewController ()<WebOperationDelegate>
@property (nonatomic, strong) ForumsWebOperation *forumWebOp;
@property (nonatomic, strong) NSMutableArray *forumsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *selectedAccount;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) UGHDataAccess *dataAccess;
- (IBAction)searchWithSubjectAction:(id)sender;
@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Forums";
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpInitialElements {
    [self homebutton];
    [self.tableView registerNib:[UINib nibWithNibName:@"GenericTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableCellIdentifier"];
    [self.navigationController.navigationBar setTranslucent:NO];
    _dataAccess = [UGHDataAccess sharedDataAccess];
    self.selectedAccount = [self.dataAccess selectedUser];
    [self retriveAllForumsWithSubject:@""];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addForum)];
}

- (void)retriveAllForumsWithSubject:(NSString *)subject {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.forumWebOp) {
        return; // web op already in progess
    }
    self.forumWebOp = [[ForumsWebOperation alloc] initWithDelegate:self];
    self.forumWebOp.societyId = self.selectedAccount.societyId;
    self.forumWebOp.subject = subject;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.forumWebOp];
}

#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    self.forumWebOp = nil;
    NSArray *response = ((ForumsWebOperation *)webOp).responseArray;
    self.forumsArray = [self forumsForResponseArray:response];
    [self.tableView reloadData];
}

- (NSMutableArray *)forumsForResponseArray:(NSArray *)array {
    if (!array) return nil;
    NSMutableArray *tempArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Forum *forum = [Forum forumFromDictionary:(NSDictionary *)obj];
        [tempArray addObject:forum];
    }];
    return tempArray;
}


#pragma mark TableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.forumsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifier"];
    [cell forumDetailsForForum:(Forum *)self.forumsArray [indexPath.row]];
    return cell;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailForumViewController *forumDetailsVc = [[DetailForumViewController alloc] initWithNibName:@"DetailForumViewController" bundle:nil];
    forumDetailsVc.forumId = ((Forum *) self.forumsArray [indexPath.row]).forumId;
    forumDetailsVc.title = ((Forum *) self.forumsArray [indexPath.row]).subject;
    [self.navigationController pushViewController:forumDetailsVc animated:YES];
}

#pragma mark Misc
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

- (IBAction)searchWithSubjectAction:(id)sender {
    [self retriveAllForumsWithSubject:[self.searchTextField.text stringByRemovingWhitespaceCharacters]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)addForum {
    AddForumViewController *addForumVc = [[AddForumViewController alloc] initWithNibName:@"AddForumViewController" bundle:nil];
    [self.navigationController pushViewController:addForumVc animated:YES];
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
