//
//  ForumDetailsWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 21/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface ForumDetailsWebOperation : WebOperation
@property (nonatomic, strong) NSString *societyId;
@property (nonatomic, strong) NSString *forumId;

//response
@property (nonatomic, strong) NSMutableArray *response;
@end
