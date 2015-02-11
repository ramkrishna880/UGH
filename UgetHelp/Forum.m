//
//  Forum.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "Forum.h"

@implementation Forum

+ (Forum *)forumFromDictionary:(NSDictionary *)dictionary {
    
    Forum *forum = [[Forum alloc]initWithDictionary:dictionary];
    return forum;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
        self.did = dict [@"DId"];
        self.forumId = dict [@"ForumId"];
        self.forumType = dict [@"ForumType"];
        self.societyId = dict [@"SocietyId"];
        self.userId = dict [@"UserId"];
        self.commentsCount = dict [@"CommentsCount"] == [NSNull null] ? 0 : [dict [@"CommentsCount"] integerValue];
        self.subject = dict [@"Subject"];
        self.comments = dict [@"Comments"];
        self.attachmentPath1 = dict [@"AttachmentPath1"];
        self.attachmentPath2 = dict [@"AttachmentPath2"];
        self.attachmentPath3 = dict [@"AttachmentPath3"];
        self.createdOn = dict [@"CreatedOn"];
        self.createdBy = dict [@"CreatedBy"];
        self.userName = dict [@"UserName"];
        self.userPhotoUrl = dict [@"UserPhoto"];
    }
    return self;
}
@end

