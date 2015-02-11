//
//  CreateForumOrTicketWebOp.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface CreateForumOrTicketWebOp : WebOperation
@property (nonatomic, strong) NSDictionary *bodyDictionary;
@property (nonatomic, assign) BOOL isForum;

@property (nonatomic, strong) id response;
@end
