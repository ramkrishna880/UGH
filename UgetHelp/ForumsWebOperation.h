//
//  ForumsWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface ForumsWebOperation : WebOperation
@property (nonatomic, strong) NSString *societyId;
@property (nonatomic, strong) NSString *subject;

@property (nonatomic, strong) NSArray *responseArray;
@end
