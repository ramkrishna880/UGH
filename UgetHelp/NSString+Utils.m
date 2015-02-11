//
//  NSString+Utils.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 07/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)



- (NSString *)stringByRemovingWhitespaceCharacters {
    NSArray *words = [self componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
    return [words componentsJoinedByString:@""];
}
- (NSString *)stringByTrimmingWhitespaces {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRemovingTabSequences {
    return [self stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@" "];
}

- (NSString *)stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)applicationImageUrlString{
    return [self substringWithRange:NSMakeRange(1, self.length-1)];
}

- (NSString *)stringByRemovingTagsAndAppendingTabs {
    NSString *string = [[self stringByReplacingOccurrencesOfString:@"</p>" withString:@" \n"] stringByStrippingHTML];
    return string;
}
@end
