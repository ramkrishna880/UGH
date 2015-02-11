//
//  GetTicketCommentsWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 03/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface GetTicketCommentsWebOperation : WebOperation
@property (nonatomic, strong) NSString *societyId;
@property (nonatomic, strong) NSString *ticketId;

@property (nonatomic, strong) NSMutableArray *response;
@end
