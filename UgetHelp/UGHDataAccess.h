//
//  UGHDataAccess.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 08/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@import SystemConfiguration;

@class User;

@interface UGHDataAccess : NSObject
+ (UGHDataAccess *)sharedDataAccess;

- (BOOL)isConnected;

#pragma mark SET val
- (void)saveAllUserDetails:(NSMutableArray *)allUsers;
- (void)saveSelectedUser:(User *)user;
- (void)saveProfileUserName:(NSString *)userName andPassword:(NSString *)password;
#pragma mark GET val
- (NSMutableArray *)allUsers;
- (User *)selectedUser;
- (NSString *)societyId;
- (NSString *)userId;
- (NSDictionary *)loginCredentials;
//Login
- (BOOL)isLoggedIn;
- (void)setLoginStatus:(BOOL)isLoggedIn;
@end
