//
//  NSDictionary+Utils.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 06/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utils)
- (NSDictionary *)dictionaryByRecursivelyRemovingNSNulls;
- (NSDictionary *)dictionaryWithOutNulls; //for exclusive Requirement
@end
