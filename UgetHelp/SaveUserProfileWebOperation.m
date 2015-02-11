//
//  SaveUserProfileWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 29/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "SaveUserProfileWebOperation.h"
#import "WebOperations.h"

@implementation SaveUserProfileWebOperation

- (void)performRequest {
    
    // part 1 - setup the API call
    NSString *urlString = [NSString stringWithFormat:@"%@/ProfileAPI/SaveProfile",API_MEMBER_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT_INTERVAL];
    
    NSDictionary *params = [NSDictionary dictionaryWithDictionary:self.paramsDictionary];
    NSError * serializeError;
    NSData *jsonParameterData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&serializeError];
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
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    if (!responseObject) {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return; // the error property should already be set
    }
    self.response = responseObject;
}
@end
