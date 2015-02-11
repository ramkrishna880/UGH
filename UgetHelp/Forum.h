//
//  Forum.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forum : NSObject
@property (nonatomic, strong) NSString *did;
@property (nonatomic, strong) NSString *forumId;
@property (nonatomic, strong) NSString *forumType;
@property (nonatomic, strong) NSString *societyId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSString *attachmentPath1;
@property (nonatomic, strong) NSString *attachmentPath2;
@property (nonatomic, strong) NSString *attachmentPath3;
@property (nonatomic, strong) NSDate *createdOn;
@property (nonatomic, strong) NSString *createdBy;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPhotoUrl;

+ (Forum *)forumFromDictionary:(NSDictionary *)dictionary;
@end
