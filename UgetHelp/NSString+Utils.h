//
//  NSString+Utils.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 07/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)
- (NSString *)stringByRemovingWhitespaceCharacters;
- (NSString *)stringByTrimmingWhitespaces;
- (NSString *)stringByRemovingTabSequences;
- (NSString *)stringByStrippingHTML;
- (NSString *)applicationImageUrlString;

- (NSString *)stringByRemovingTagsAndAppendingTabs;
@end
