//
//  SaveCommentWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 28/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "SaveCommentWebOperation.h"
#import "WebOperations.h"
#import "NSData+StringEncodings.h"

@implementation SaveCommentWebOperation


- (void)performRequest {
    // part 1 - setup the API call
    NSString *urlString;
    if (self.isForum) {
        urlString = [NSString stringWithFormat:@"%@/ForumAPI/SaveComment", API_BASE_URL];
    }else{
        urlString = [NSString stringWithFormat:@"%@/TicketsAPI/SaveComment", API_BASE_URL];
    }
    //    NSString *urlString = [NSString stringWithFormat:@"%@/ForumAPI/SaveComment", API_BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT_INTERVAL];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:self.paramDictionary];
    NSError * serializeError;
    NSData *jsonParameterData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&serializeError];
    request.HTTPMethod = @"POST";
    [request setHTTPBody:jsonParameterData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    // part 2 - make the call & handle errors
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        self.error = error;
        [self checkIf401Error];
        return;
    }
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&serializeError];
    if (!responseObject) {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return; // the error property should already be set
    }
    if (![responseObject isKindOfClass:[NSDecimalNumber class]]) {
        ShowAlert(@"", @"Unknown Response")
    }
    self.response = responseObject;
}

@end
