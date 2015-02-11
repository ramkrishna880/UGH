//
//  Event.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
//new
//@property (nonatomic, strong) NSString *max;
//@property (nonatomic, strong) NSString *min;

@property (nonatomic, strong) NSString *did;
@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *societyId;
@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *toDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *eventDescription;
@property (nonatomic, assign) BOOL sendSms;
@property (nonatomic, assign) BOOL sendEmail;
@property (nonatomic, strong) NSString *attachmentPath1;
@property (nonatomic, strong) NSString *attachmentPath2;
@property (nonatomic, strong) NSString *attachmentPath3;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSDate *updatedOn;
@property (nonatomic, strong) NSString *updatedBy;
@property (nonatomic, assign) BOOL reminderBefore;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *userName;

#pragma Mark Method
+ (Event *)eventFromDictionary:(NSDictionary *)dictionary;
@end
