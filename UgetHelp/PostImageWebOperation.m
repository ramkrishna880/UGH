//
//  PostImageWebOperation.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "PostImageWebOperation.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"

@implementation PostImageWebOperation
- (void)performRequest {
    UGHDataAccess *dataAccess = [UGHDataAccess sharedDataAccess];
    if (!self.fileIndexNumber) self.fileIndexNumber = @"1";
    // part 1 - setup the API call
    NSString *urlString = [NSString stringWithFormat:@"%@/BaseAPI/MobileUpload",API_BASE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT_INTERVAL];
    NSDictionary *parameters = @{@"ImageBytes":self.imageBytesArray,@"SocietyId":dataAccess.societyId,@"UserId":dataAccess.userId,@"FileIndexNumber":self.fileIndexNumber};
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
        return; // the error property should already be set
    }
    if (![responseObject isKindOfClass:[NSString class]]) {
        ShowAlert(@"postFailed", @"Unknown Response")
    }
    self.imagePath = responseObject;
}
@end
