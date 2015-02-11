//
//  User.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 19/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *societyId;
@property (nonatomic, assign)BOOL isAdmin;
@property (nonatomic, assign)BOOL isMember;
@property (nonatomic, strong)NSString *accessId;
@property (nonatomic, strong)NSString *flatId;
@property (nonatomic, strong)NSString *flatNumber;
@property (nonatomic, strong)NSString *blockId;
@property (nonatomic, strong)NSString *blockName;
@property (nonatomic, assign)BOOL isResident;
@property (nonatomic, assign)BOOL isOwner;
@property (nonatomic, strong)NSString *residenceGroupId;
@property (nonatomic, strong)NSString *logoUrl;
@property (nonatomic, strong)NSString *societyName;
@property (nonatomic, strong)NSString *lastLoginSociety;
@property (nonatomic, strong)NSString *memberLastLoginSociety;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *profilePictureUrl;
@property (nonatomic, strong)NSString *email;

+ (User *)userFromDictionary:(NSDictionary *)dictionary;
@end

