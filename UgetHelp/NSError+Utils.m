//
//  NSError+Utils.m
//  CustomerSelfService
//
//  Copyright (c) 2014 tricolor auto group. All rights reserved.
//

#import "NSError+Utils.h"

#import "WebOperations.h"

@implementation NSError (Utils)

+ (NSError *)errorFor401HTTPStatus {
    return [NSError errorWithDomain:ERROR_DOMAIN code:401 userInfo:@{NSLocalizedDescriptionKey:@"Unauthorized."}];
}
+ (NSError *)errorWithDictionary:(NSDictionary *)dictionary {
    return [NSError errorWithDomain:ERROR_DOMAIN code:[dictionary[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:Stringify(dictionary[@"message"])}];
}
- (BOOL)is401Error {
    return self.code == 401;
}
- (BOOL)is401ErrorForCFNetworking {
    return [self.domain isEqualToString:@"NSURLErrorDomain"] && self.code == kCFURLErrorUserCancelledAuthentication;
}

@end
