//
//  UserProfileWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 29/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface UserProfileWebOperation : WebOperation
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSDictionary *responseDictionary;
@end
