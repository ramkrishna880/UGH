//
//  NSError+Utils.h
//  CustomerSelfService
//
//  Copyright (c) 2014 tricolor auto group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Utils)

+ (NSError *)errorFor401HTTPStatus;
+ (NSError *)errorWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, readonly) BOOL is401Error;
@property (nonatomic, readonly) BOOL is401ErrorForCFNetworking;

@end
