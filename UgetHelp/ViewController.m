//
//  ViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/12/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import "ViewController.h"
#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginWebOperation.h"
#import "NSString+Utils.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"
#import "User.h"

@interface ViewController ()<WebOperationDelegate,SWRevealViewControllerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)IBOutlet UITextField *usernameTextField;
@property(nonatomic,strong)IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) LoginWebOperation *loginWebOp;
@property (nonatomic, strong) UGHDataAccess *dataAcess;
- (IBAction)login:(id)sender;
@end

#define KoffsetKeyboard 80.0f
@implementation ViewController


#pragma mark View life Cycle & like
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialElements];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)setUpInitialElements {
    self.title = @"Login";
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.dataAcess = [UGHDataAccess sharedDataAccess];
    [self registerForNotifications:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [self registerForNotifications:NO];
}

#pragma mark Actions
- (IBAction)login:(id)sender {
    if (![self.dataAcess isConnected]) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (!self.usernameTextField.text.length || !self.passwordTextField.text.length) {
        ShowAlert(@"Login", @"Enter Email or Password");
    }else if(![self isValidEmail:[self.usernameTextField.text stringByTrimmingWhitespaces]]) {
        [self.usernameTextField becomeFirstResponder];
        ShowAlert(@"Login", @"Enter Valid Email");
    }else{
        [self loginUserForEmailId:[self.usernameTextField.text stringByTrimmingWhitespaces] password:[self.passwordTextField.text stringByTrimmingWhitespaces]];
    }
}

#pragma mark Network Operations
- (void)loginUserForEmailId:(NSString *)email password:(NSString *)password {
    if (self.loginWebOp) {
        return; // web op already in progess
    }
    self.loginWebOp = [[LoginWebOperation alloc] initWithDelegate:self];
    self.loginWebOp.emailId = email;
    self.loginWebOp.password = password;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.loginWebOp];
}

#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    self.loginWebOp = nil;
    NSMutableArray *response = ((LoginWebOperation *)webOp).response;
    if (response) {
        [self validateLoginForResponse:response];
    }
}

#pragma mark Misc & like
- (void)showHomeView {
    [self.dataAcess setLoginStatus:YES];
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    SidebarViewController *sideViewController = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sideViewController];
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    revealController.delegate = self;
    [self presentViewController:revealController animated:NO completion:nil];
}
- (BOOL)isValidEmail:(NSString *)mailId {
    NSString *emailRegex = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:mailId];
}

- (void)validateLoginForResponse:(NSMutableArray *)responseArray {
    if (responseArray.count == 1) {
        NSDictionary *singleUserResponse = responseArray[0];
        if (singleUserResponse.count == 1 && [[singleUserResponse allKeys] containsObject:KERROR_MSG_KEY]) {
            ShowAlert(@"Error", [singleUserResponse valueForKey:KERROR_MSG_KEY]);
        }else if (singleUserResponse.count>1) {
            [self.dataAcess saveSelectedUser:[User userFromDictionary:singleUserResponse]];
            [self.dataAcess saveProfileUserName:self.usernameTextField.text andPassword:self.passwordTextField.text];
            [self showHomeView];
        }else{
            ShowAlert(@"Login", @"unknown response Error. Please try again");
        }
    }else{
        NSMutableArray *allActiveUsers = [NSMutableArray new];
        [responseArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj valueForKey:@"IsMember"] boolValue]) {
                [allActiveUsers addObject:[User userFromDictionary:(NSDictionary *)obj]];
            }
        }];
        
        if (allActiveUsers.count == 1) {
            [self.dataAcess saveSelectedUser:allActiveUsers[0]];
        }else{
            [self.dataAcess saveAllUserDetails:allActiveUsers];
        }
        [self.dataAcess saveProfileUserName:self.usernameTextField.text andPassword:self.passwordTextField.text];
        [self showHomeView];
    }
}

#pragma mark TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Notifications & the like
- (void)registerForNotifications:(BOOL)shouldRegister {
    if (shouldRegister) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect frame = self.view.frame;
    frame.origin.y -= KoffsetKeyboard;
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.view.frame = frame;
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.view.frame;
    frame.origin.y -= -KoffsetKeyboard;
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.view.frame =frame;
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
