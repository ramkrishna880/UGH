//
//  GetMaintenanceRecieptsWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 06/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "GetMaintenanceRecieptsWebOperation.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"
#import "User.h"
@implementation GetMaintenanceRecieptsWebOperation


- (void)performRequest {
    //prerequisites
    UGHDataAccess *dataAccess = [UGHDataAccess sharedDataAccess];
    User *user = dataAccess.selectedUser;
    // part 1 - setup the API call
    NSString *urlString = [NSString stringWithFormat:@"%@/MaintenanceReceiptsAPI/GetMaintenanceReceipts?BlockId=%@&FlatId=%@&ProfileId=%@",API_MEMBER_URL,user.blockId,user.flatId,user.userId];
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
        return;
    }
    self.maintenanceRecieptsResponse = responseObject;
}

@end
