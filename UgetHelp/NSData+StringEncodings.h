//
//  NSData+StringEncodings.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 30/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (StringEncodings)
- (NSString *)base64Encoded;
- (NSArray *)bytesArray;
@end
