//
//  UserProfileWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 29/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "UserProfileWebOperation.h"
#import "WebOperations.h"

@implementation UserProfileWebOperation

- (void)performRequest {
    
    // part 1 - setup the API call
    NSString *urlString = [NSString stringWithFormat:@"%@/ProfileAPI/GetUserProfile?UserId=%@&Password=%@",API_MEMBER_URL,self.userId,self.password];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT_INTERVAL];
    request.HTTPMethod = @"GET";
    
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
    self.responseDictionary = responseObject[0];
}
@end
