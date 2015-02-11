//
//  NSDictionary+Utils.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 06/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "NSDictionary+Utils.h"
#import "NSArray+Utils.h"

@implementation NSDictionary (Utils)

- (NSDictionary *)dictionaryByRecursivelyRemovingNSNulls {
    
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            [mutableDictionary setObject:@"" forKey:key];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            [mutableDictionary setObject:[(NSArray *)obj arrayByRecursivelyRemovingNSNulls] forKey:key];
        }
        else if ([obj isKindOfClass:[NSDictionary class]]) {
            [mutableDictionary setObject:[(NSDictionary *)obj dictionaryByRecursivelyRemovingNSNulls] forKey:key];
        }
        else {
            [mutableDictionary setObject:obj forKey:key];
        }
    }];
    return [[NSDictionary alloc] initWithDictionary:mutableDictionary copyItems:NO];
}

- (NSDictionary *)dictionaryWithOutNulls {
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNull class]]) {
            // skipping
        }else {
            [mutableDictionary setObject:obj forKey:key];
        }
    }];
    return [[NSDictionary alloc] initWithDictionary:mutableDictionary copyItems:NO];
}
@end
