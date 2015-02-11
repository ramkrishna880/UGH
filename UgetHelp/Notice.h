//
//  Notice.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject
//new
//@property (nonatomic, strong) NSString *max;
//@property (nonatomic, strong) NSString *min;

@property (nonatomic, strong) NSString *noticeId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *societyId;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *noticeDescription;
@property (nonatomic, assign) BOOL sendEmail;
@property (nonatomic, assign) BOOL sendSms;
@property (nonatomic, strong) NSString *attachmentPath1;
@property (nonatomic, strong) NSString *attachmentPath2;
@property (nonatomic, strong) NSString *attachmentPath3;
@property (nonatomic, assign) BOOL noticeToAll;
@property (nonatomic, assign) BOOL noticeToOwners;
@property (nonatomic, assign) BOOL noticeToResidents;
@property (nonatomic, assign) BOOL noticeToBoardMembers;
@property (nonatomic, assign) BOOL noticeToSocietyStaff;
@property (nonatomic, assign) BOOL noticeToSpecific;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSDate *updatedOn;
@property (nonatomic, strong) NSString *updatedBy;
@property (nonatomic, strong) NSString *userPhotoUrl;

+ (Notice *)noticeFromDictionary:(NSDictionary *)dictionary;
@end

