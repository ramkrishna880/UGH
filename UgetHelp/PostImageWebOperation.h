//
//  PostImageWebOperation.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//


#import "WebOperation.h"

@interface PostImageWebOperation : WebOperation
@property (nonatomic, strong) id imageBytesArray;
@property (nonatomic, strong) NSString *fileIndexNumber;
@property (nonatomic, strong) NSString *imagePath;
@end
