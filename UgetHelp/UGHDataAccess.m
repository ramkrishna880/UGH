//
//  UGHDataAccess.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 08/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "UGHDataAccess.h"
#import "SynthesizeSingleton.h"
#import "User.h"
#import "WebOperations.h"
#import "PostImageWebOperation.h"

static NSString * const SELECTED_USER_KEY = @"selected_User";
static NSString * const LOGIN_STATUS_KEY = @"Login_Status";
static NSString * const LOGIN_CREDENTIALS_KEY = @"Login_credentials";

@interface UGHDataAccess ()<WebOperationDelegate>
@property (nonatomic, strong)PostImageWebOperation *postImageWebOp;
@end
@implementation UGHDataAccess

+ (UGHDataAccess *)sharedDataAccess {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}
- (BOOL)isLoggedIn {
    BOOL isloggedIn = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_STATUS_KEY];
    return isloggedIn ? isloggedIn :NO;
}

- (NSMutableArray *)allUsers {
    NSMutableArray *users =[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO_KEY]];
    return  users ? users : nil;
}

- (User *)selectedUser {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTED_USER_KEY];
    NSArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dataArray ? dataArray[0] : nil;
}

- (NSString *)societyId {
    User *user = [self selectedUser];
    return user.societyId ? user.societyId : nil;
}
- (NSDictionary *)loginCredentials {
    NSDictionary *credentials = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_CREDENTIALS_KEY];
    return credentials ? credentials : nil;
}

- (NSString *)userId {
    User *user = [self selectedUser];
    return user.userId ? user.userId : nil;
}

- (void)saveSelectedUser:(User *)user {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (user) {
        NSArray *userArray = [[NSArray alloc]initWithObjects:user,nil];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userArray];
        [standardUserDefaults setObject:data forKey:SELECTED_USER_KEY];
    }
    else {
        [standardUserDefaults removeObjectForKey:SELECTED_USER_KEY];
    }
    
}

- (void)saveAllUserDetails:(NSMutableArray *)allUsers {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (allUsers) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allUsers];
        [standardUserDefaults setObject:data forKey:USER_INFO_KEY];
    }
    else {
        [standardUserDefaults removeObjectForKey:USER_INFO_KEY];
    }
    [standardUserDefaults synchronize];
}

- (void)setLoginStatus:(BOOL)isLoggedIn {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (isLoggedIn) {
        [standardUserDefaults setBool:isLoggedIn forKey:LOGIN_STATUS_KEY];
    }
    else {
        [standardUserDefaults removeObjectForKey:LOGIN_STATUS_KEY];
    }
    
}

- (void)saveProfileUserName:(NSString *)userName andPassword:(NSString *)password {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (userName && password) {
        NSDictionary *params = @{KEMAIL:userName,KPASSWORD:password};
        [standardUserDefaults setObject: params forKey:LOGIN_CREDENTIALS_KEY];
    }
    else {
        [standardUserDefaults removeObjectForKey:LOGIN_CREDENTIALS_KEY];
    }
}
#pragma mark Check Internet connection
- (BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)postImage:(id)bytesArray {
    if (self.postImageWebOp) {
        return;
    }
    self.postImageWebOp = [[PostImageWebOperation alloc] initWithDelegate:self];
    self.postImageWebOp.imageBytesArray = bytesArray;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.postImageWebOp];
}

- (void)webOperationCompleted:(WebOperation *)webOp {
    if (webOp == self.postImageWebOp) {
        self.postImageWebOp = nil;
        NSString *path = ((PostImageWebOperation *)webOp).imagePath;
        if (!path) {
            return;
        }
    }
}
@end
