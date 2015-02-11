//
//  SaveUserProfileWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 29/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface SaveUserProfileWebOperation : WebOperation
@property (nonatomic, strong) NSDictionary *paramsDictionary;

@property (nonatomic, strong) id response;
@end
