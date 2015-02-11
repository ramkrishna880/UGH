//
//  CreateForumOrTicketWebOp.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "CreateForumOrTicketWebOp.h"
#import "WebOperations.h"

@implementation CreateForumOrTicketWebOp

- (void)performRequest {
    NSString *urlString;
    if (self.isForum) {
        urlString = [NSString stringWithFormat:@"%@/ForumAPI/SaveForum", API_MEMBER_URL];
    }else {
        urlString = [NSString stringWithFormat:@"%@/TicketsAPI/CreateTicket", API_MEMBER_URL];
    }
    // part 1 - setup the API call
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT_INTERVAL];
    NSDictionary *parameters = [NSDictionary dictionaryWithDictionary:self.bodyDictionary];
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
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if (!responseObject) {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        return;
    }
    if (![responseObject isKindOfClass:[NSDecimalNumber class]]) {
     ShowAlert(@"", @"Un known Response")
        return;
    }
    self.response = responseObject;
}

@end