//
//  NSArray+Utils.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 06/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "NSArray+Utils.h"
#import "NSDictionary+Utils.h"
@implementation NSArray (Utils)

- (NSArray *)arrayByRecursivelyRemovingNSNulls {
    
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.count];
    for (id thing in self) {
        if ([thing isKindOfClass:[NSNull class]]) {
            // ignoring
            [mutableArray addObject:@""];
        }
        else if ([thing isKindOfClass:[NSDictionary class]]) {
            [mutableArray addObject:[(NSDictionary *)thing dictionaryByRecursivelyRemovingNSNulls]];
        }
        else if ([thing isKindOfClass:[NSArray class]]) {
            [mutableArray addObject:[(NSArray *)thing arrayByRecursivelyRemovingNSNulls]];
        }
        else {
            [mutableArray addObject:thing];
        }
    }
    return [[NSArray alloc] initWithArray:mutableArray copyItems:NO];
}

@end
