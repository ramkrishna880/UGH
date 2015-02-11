//
//  Ticket.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 02/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject

@property (nonatomic, strong) NSString *did;
@property (nonatomic, strong) NSString *ticketId;
@property (nonatomic, strong) NSString *societyId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *issueType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSDate *ticketDate;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *ticketDescription;
@property (nonatomic, strong) NSString *assignedToUserId;
@property (nonatomic, strong) NSString *statusId;
@property (nonatomic, strong) NSString *blockId;
@property (nonatomic, strong) NSString *flatId;
@property (nonatomic, strong) NSString *ticketPriority;
@property (nonatomic, strong) NSString *attachmentPath1;
@property (nonatomic, strong) NSString *attachmentPath2;
@property (nonatomic, strong) NSString *attachmentPath3;
@property (nonatomic, strong) NSString *rating;

@property (nonatomic, strong) NSDate *updatedDate;

+ (Ticket *)ticketFromDictionary:(NSDictionary *)dictionary;
+ (Ticket *)ticketCommentFromDictionary:(NSDictionary *)dictionary;
@end
