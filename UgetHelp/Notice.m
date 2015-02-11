//
//  Notice.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "Notice.h"

@implementation Notice

+ (Notice *)noticeFromDictionary:(NSDictionary *)dictionary {
    
    Notice *notice = [[Notice alloc]initWithDictionary:dictionary];
    return notice;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if ([dict isKindOfClass:[NSDictionary class]]) {
      
        self.noticeId = dict [@"NoticeId"];
        self.userName = dict [@"UserName"];
        self.societyId = dict [@"SocietyId"];
        self.subject = dict [@"Subject"];
        self.noticeDescription = dict [@"Description"];
        self.sendEmail = (dict [@"SendEmail"] == [NSNull null]) ? NO : [dict [@"SendEmail"] boolValue];
        self.sendSms =  (dict [@"SendSMS"] == [NSNull null]) ? NO : [dict [@"SendSMS"] boolValue];
        self.attachmentPath1 = dict [@"AttachmentPath1"];
        self.attachmentPath2 = dict [@"AttachmentPath2"];
        self.attachmentPath3 = dict [@"AttachmentPath3"];
        self.noticeToAll = (dict [@"Notice2All"] == [NSNull null]) ? NO : [dict [@"Notice2All"] boolValue];
        self.noticeToOwners = (dict [@"Notice2Owners"] == [NSNull null]) ? NO : [dict [@"Notice2Owners"] boolValue];
        self.noticeToResidents = (dict [@"Notice2Residents"] == [NSNull null]) ? NO : [dict [@"Notice2Residents"] boolValue];
        self.noticeToBoardMembers = (dict [@"Notice2BoardMembers"] == [NSNull null]) ? NO : [dict [@"Notice2BoardMembers"] boolValue];
        self.noticeToSocietyStaff = (dict [@"Notice2SocietyStaff"] == [NSNull null]) ? NO : [dict [@"Notice2SocietyStaff"] boolValue];
        self.noticeToSpecific = (dict [@"Notice2Specific"] == [NSNull null]) ? NO : [dict [@"Notice2Specific"] boolValue];
        self.createdOn = dict [@"CreatedOn"];
        self.createdBy = dict [@"CreatedBy"];
        self.updatedOn = dict [@"UpdatedOn"];
        self.updatedBy = dict [@"UpdatedBy"];
        self.userPhotoUrl = dict [@"UserPhoto"];
        
        //new
//        self.max = dict [@"MAX"];
//        self.min = dict [@"MIN"];
    }
    return self;
}
@end

 