//
//  WebOperation.h
//
//
//  Copyright (c)  rights reserved.
//

@class WebOperation;
@class ASIHTTPRequest;

#import <UIKit/UIKit.h>

@protocol WebOperationDelegate <NSObject>

- (void)webOperationCompleted:(WebOperation *)webOp;

@optional
- (void)handleNotification:(NSNotification *)notification;

@end

@interface WebOperation : NSOperation

@property (weak) id<WebOperationDelegate> delegate;
@property (strong) NSError *error;

- (id)initWithDelegate:(id<WebOperationDelegate>)theDelegate;
- (void)performRequest;
- (void)checkIf401Error;
- (NSDictionary *)deserializeData:(NSData *)data;

@end

