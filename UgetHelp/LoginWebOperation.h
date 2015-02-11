//
//  LoginWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 07/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface LoginWebOperation : WebOperation
@property (nonatomic, strong) NSString *emailId;
@property (nonatomic, strong) NSString *password;

//response
@property (nonatomic, strong) NSMutableArray *response;
@end
