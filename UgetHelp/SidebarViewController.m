//
//  SidebarViewController.m
//  UgetHelp
//
//  Created by A3it on 12/10/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import "SidebarViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "HomeViewController.h"
#import "MaintenanceRecieptsViewController.h"
#import "EventsViewController.h"
#import "TicketsViewController.h"
#import "UGHDataAccess.h"
#import "WebOperations.h"
#import "NoticesViewController.h"
#import "ForumViewController.h"
#import "User.h"
#import "ProfileViewController.h"


#define TableImgKey @"image"
#define TableMenuListKey @"menuList"

@interface SidebarViewController ()
@property (nonatomic, strong)NSArray *listArray;
@property (nonatomic, strong) UGHDataAccess *dataAccess;
@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *blockNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *flatNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *societyNameLbl;
@end

@implementation SidebarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialUIElements];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpInitialUIElements {
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    self.user = self.dataAccess.selectedUser;
    
    self.userImage.layer.cornerRadius=self.userImage.frame.size.height/2;;
    self.userImage.clipsToBounds=YES;
    
    self.nameLbl.text= self.user.name;
    self.flatNumberLbl.text = [NSString stringWithFormat:@"Flat No: %@",self.user.flatNumber];
    self.blockNameLbl.text = [NSString stringWithFormat:@"Block : %@",self.user.blockName];
    self.societyNameLbl.text= self.user.societyName;
    NSString *strUrl =[NSString stringWithFormat:@"%@/%@",API_BASE_IMAGE_URL,self.user.profilePictureUrl];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:PLACEHOLDER];
    
    _listArray=[[NSArray alloc]initWithObjects:@{TableImgKey : @"menu_notice", TableMenuListKey : @"Notices"},
                @{TableImgKey : @"menu_event", TableMenuListKey : @"Events"},
                @{TableImgKey : @"menu_ticket", TableMenuListKey : @"Tickets"},
                @{TableImgKey : @"menu_photo_gallery", TableMenuListKey : @"Photo Gallary"},
                @{TableImgKey : @"menu_forum", TableMenuListKey : @"Forum"},
                @{TableImgKey : @"menu_maintenance_reciepts", TableMenuListKey : @"Maintainance Reciepts"},
                @{TableImgKey : @"menu_logout", TableMenuListKey : @"Logout"},nil];
    
    UIImageView *leftBarbuttonView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 1, 80, 40)];
    [leftBarbuttonView setImage:[UIImage imageNamed:@"login_logo.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarbuttonView];
}

#pragma mark TableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_listArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:[[_listArray objectAtIndex:indexPath.row] valueForKey:TableImgKey]];
    cell.textLabel.text=[[_listArray objectAtIndex:indexPath.row] valueForKey:TableMenuListKey];
    return cell;
}

#pragma Mark Tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <--
    
    if (indexPath.row == 0) {
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] ) {
            NoticesViewController *noticesViewController = [[NoticesViewController alloc] initWithNibName:@"NoticesViewController" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:noticesViewController];
            [revealController setFrontViewController:navigationController animated:NO];
            [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        }else {
            [revealController revealToggle:self];
        }
    }else if (indexPath.row == 1) {
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]]) {
            EventsViewController *view = [[EventsViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:view];
            [revealController setFrontViewController:navigationController animated:NO];
            [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        } else {
            [revealController revealToggle:self];
        }
    } else if (indexPath.row == 2) {
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]]) {
            TicketsViewController *view = [[TicketsViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:view];
            [revealController setFrontViewController:navigationController animated:NO];
            [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        } else {
            [revealController revealToggle:self];
        }
    } else if (indexPath.row == 3) {
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]]) {
            ShowAlert(@"", @"not Done")
        } else {
            [revealController revealToggle:self];
        }
    }else if (indexPath.row == 4) {
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] )  {
            ForumViewController *forumVc = [[ForumViewController alloc] initWithNibName:@"ForumViewController" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:forumVc];
            [revealController setFrontViewController:navigationController animated:NO];
            [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        } else {
            [revealController revealToggle:self];
        }
    }else if (indexPath.row == 5)
    {
        if ( ![frontNavigationController.topViewController isKindOfClass:[ViewController class]] ) {
            MaintenanceRecieptsViewController *maintenanceReciepts = [[MaintenanceRecieptsViewController alloc] initWithNibName:@"MaintenanceRecieptsViewController" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:maintenanceReciepts];
            [revealController setFrontViewController:navigationController animated:NO];
            [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        } else {
            [revealController revealToggle:self];
        }
    } else if (indexPath.row == 6) {
        [self.dataAccess setLoginStatus:NO];
        [appDelegate performLoginIfNeeded];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (IBAction)profileViewTapped:(id)sender {
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    if ( ![frontNavigationController.topViewController isKindOfClass:[ProfileViewController class]] ) {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    } else {
        [revealController revealToggle:self];
    }
}
@end
