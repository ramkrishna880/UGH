//
//  SaveCommentWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 28/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "WebOperation.h"

@interface SaveCommentWebOperation : WebOperation
@property (nonatomic, assign) BOOL isForum;
@property (nonatomic, strong) NSDictionary *paramDictionary;
//after response
@property (nonatomic, strong) id response;
@end
