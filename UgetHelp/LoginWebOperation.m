//
//  LoginWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 07/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "LoginWebOperation.h"
#import "WebOperations.h"
@implementation LoginWebOperation

- (void)performRequest {

    // part 1 - setup the API call
    NSString *urlString = [NSString stringWithFormat:@"%@/LoginAPI/ValidateLogin", API_BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT_INTERVAL];
    NSDictionary *parameters = @{@"Email":self.emailId,@"Password":self.password};
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
    
    id responseObject = [self deserializeData:responseData];
    if (!responseObject) {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return; // the error property should already be set
    }
    self.response = responseObject;
}

@end
