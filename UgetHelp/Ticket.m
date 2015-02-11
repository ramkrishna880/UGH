//
//  Ticket.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 02/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "Ticket.h"

static NSString * const TDID = @"DId";
static NSString * const TSOCIETYID = @"SocietyId";
static NSString * const TTICKETID = @"TicketId";
static NSString * const TSTATUSID = @"StatusId";
static NSString * const TNAME = @"Name";
static NSString * const TPHOTOURL = @"Photo";
static NSString * const TDESCRIPTION = @"Description";
static NSString * const TATTACH1 = @"AttachmentPath1";
static NSString * const TATTACH2 = @"AttachmentPath2";
static NSString * const TATTACH3 = @"AttachmentPath3";
static NSString * const TUPDATED = @"UpdateDateTime";

@implementation Ticket

+ (Ticket *)ticketFromDictionary:(NSDictionary *)dictionary {
    Ticket *ticket = [[Ticket alloc]initWithDictionary:dictionary];
    return ticket;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
        self.did = dict [@"DId"];
        self.ticketId = dict [@"TicketId"];
        self.societyId = dict[@"SocietyId"];
        self.categoryName = dict [@"CategoryName"];
        self.issueType = dict [@"IssueType"];
        self.name = dict [@"Name"];
        self.photoUrl = dict [@"Photo"];
        self.ticketDate = dict [@"TicketDate"];
        self.subject = dict [@"Subject"];
        self.ticketDescription = dict [@"Description"];
        self.assignedToUserId = dict [@"AssignedToUserId"];
        self.statusId = dict [@"StatusId"];
        self.blockId = dict [@"BlockId"];
        self.flatId = dict [@"FlatId"];
        self.ticketPriority = dict [@"TicketPriority"];
        self.attachmentPath1 = dict [@"AttachmentPath1"];
        self.attachmentPath2 = dict [@"AttachmentPath2"];
        self.attachmentPath3 = dict [@"AttachmentPath3"];
        self.rating = dict [@"Rating"];
    }
    return self;
}

+ (Ticket *)ticketCommentFromDictionary:(NSDictionary *)dictionary {
    Ticket *ticket = [[Ticket alloc] initTicketCommentWithDictionary:dictionary];
    return ticket;
}

- (instancetype)initTicketCommentWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.did = dict [TDID];
        self.societyId = dict [TSOCIETYID];
        self.ticketId = dict [TTICKETID];
        self.statusId = dict [TSTATUSID];
        self.name = dict [TNAME];
        self.photoUrl = dict [TPHOTOURL];
        self.ticketDescription = dict [TDESCRIPTION];
        self.attachmentPath1 = dict [TATTACH1];
        self.attachmentPath2 = dict [TATTACH2];
        self.attachmentPath3 = dict [TATTACH3];
        self.updatedDate = dict [TUPDATED];
    }
    return self;
}
@end