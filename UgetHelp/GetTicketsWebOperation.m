//
//  GetTicketsWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 02/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "GetTicketsWebOperation.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"
#import "User.h"

@interface GetTicketsWebOperation ()
@end
@implementation GetTicketsWebOperation

- (void)performRequest {
    UGHDataAccess *dataAccess = [UGHDataAccess sharedDataAccess];
    User *user = dataAccess.selectedUser;

    // part 1 - setup the API call
    NSString *urlString = [NSString stringWithFormat:@"%@/TicketsAPI/GetTickets?SocietyId=%@&Subject=%@&StatusId=%@&CreatedBy=%@&BlockId=%@&FlatId=%@",API_MEMBER_URL,dataAccess.societyId,self.subject,self.statusId,dataAccess.userId,user.blockId,user.flatId];
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
    self.responseArray = responseObject;
}
@end
