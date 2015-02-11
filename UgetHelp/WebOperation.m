//
//  WebOperation.m
//
//
//  Copyright (c) . All rights reserved.
//

#import "WebOperations.h"
#import "NSError+Utils.h"

@implementation WebOperation

- (id)initWithDelegate:(id<WebOperationDelegate>)theDelegate {
    if (self = [super init]) {
        [self setDelegate:theDelegate];
    }

    return self;
}

- (void)main {
    @autoreleasepool {
        if ([self isCancelled]) {
            return;
        }

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        [self performRequest];
        [(NSObject *)_delegate performSelectorOnMainThread:@selector(webOperationCompleted:) withObject:self waitUntilDone:NO];

        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

#pragma mark -
- (void)performRequest {
    // method to be implemented by subclasses
}
- (NSArray *)deserializeData:(NSData *)data {
    NSError *error = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        self.error = error;
        return nil;
    }

    if (![responseObject isKindOfClass:[NSArray class]]) {
        self.error = [NSError errorWithDomain:ERROR_DOMAIN code:0 userInfo:@{NSLocalizedDescriptionKey:@"Unexpected server response"}];
        return nil;
    }

    return responseObject;
}
- (void)checkIf401Error {
    if (self.error.is401ErrorForCFNetworking) { //CFNetwork is capturing the API's 401 HTTP status code and doing bad things with it so will swap it out to something more presentable
        self.error = [NSError errorFor401HTTPStatus];
    }
}
@end
