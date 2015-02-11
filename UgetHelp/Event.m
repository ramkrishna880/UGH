//
//  Event.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "Event.h"
#import "NSDictionary+Utils.h"

@implementation Event

#pragma Mark -
+ (Event *)eventFromDictionary:(NSDictionary *)dictionary {
    
    Event *event = [[Event alloc]initWithDictionary:dictionary];
    return event;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
    
        NSDictionary *dict = [dictionary dictionaryByRecursivelyRemovingNSNulls];
//new
//        self.max = dict [@"MAX"];
//        self.min = dict [@"MIN"];
        
        self.did = dict[@"DId"];
        self.EventId = dict [@"EventId"];
        self.SocietyId = dict [@"SocietyId"];
        self.fromDate = dict [@"FromDate"];
        self.toDate = dict [@"ToDate"];
        self.name = dict [@"Name"];
        self.eventDescription = dict [@"Description"];
        self.sendSms = [dict [@"SendSMS"] boolValue];
        self.sendEmail = [dict [@"SendEmail"] boolValue];
        self.attachmentPath1 = dict [@"AttachmentPath1"];
        self.attachmentPath2 = dict [@"AttachmentPath2"];
        self.attachmentPath3 = dict [@"AttachmentPath3"];
        self.createdOn = dict [@"CreatedOn"];
        self.createdBy = dict [@"CreatedBy"];
        self.updatedOn = dict [@"UpdatedOn"];
        self.updatedBy = dict [@"UpdatedBy"];
        self.reminderBefore = [dict [@"RemainderBefore"] boolValue];
        self.photoUrl = dict [@"Photo"];
        self.userName = dict [@"UserName"];
    }
    return self;
}

@end


