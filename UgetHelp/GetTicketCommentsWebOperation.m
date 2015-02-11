//
//  GetTicketCommentsWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 03/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "GetTicketCommentsWebOperation.h"
#import "WebOperations.h"

@implementation GetTicketCommentsWebOperation

- (void)performRequest {
  
    NSString *urlString = [NSString stringWithFormat:@"%@/TicketsAPI/GetComments?SocietyId=%@&TicketId=%@",API_MEMBER_URL,self.societyId,self.ticketId];
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
    self.response = responseObject;
}
@end
