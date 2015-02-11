//
//  GetTicketsWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 02/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface GetTicketsWebOperation : WebOperation
@property (nonatomic,strong) NSString *subject;
@property (nonatomic,strong) NSString *statusId;

@property (nonatomic, strong) NSMutableArray *responseArray;
@end
