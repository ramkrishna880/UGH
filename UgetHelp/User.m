//
//  User.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 19/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "User.h"

@implementation User

static NSString * const KUSERID = @"UserId";
static NSString * const KSOCIETYID = @"SocietyId";
static NSString * const KISADMIN = @"IsAdmin";
static NSString * const KISMEMBER = @"IsMember";
static NSString * const KACCESSID = @"AccessId";
static NSString * const KFLATID = @"FlatId";
static NSString * const KFLATNUMBER = @"FlatNumber";
static NSString * const KBLOCKID = @"BlockId";
static NSString * const KBLOCKNAME = @"BlockName";
static NSString * const KISRECIDENT = @"IsResident";
static NSString * const KISOWNER = @"IsOwner";
static NSString * const KRESIDENCEGROUPID = @"ResidenceGroupId";
static NSString * const KLOGOIMAGE = @"Logo";
static NSString * const KSOCIETYNAME = @"SocietyName";
static NSString * const KLASTLOGINSOCIETY = @"LastLoginSociety";
static NSString * const KMEMBERLASTLOGINSOCIETY = @"MemberLastLoginSociety";
static NSString * const KNAME = @"Name";
static NSString * const KPROFILEPIC = @"ProfilePicture";
static NSString * const KEMAILID = @"Email";


#pragma Mark -
+ (User *)userFromDictionary:(NSDictionary *)dictionary {
    
    User *user = [[User alloc]initWithDictionary:dictionary];
    return user;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
        self.userId = dict [KUSERID];
        self.societyId = dict [KSOCIETYID];
        self.isAdmin = [dict [KISADMIN] boolValue];
        self.isMember = dict [KISMEMBER];
        self.accessId = dict [KACCESSID];
        self.flatId = dict [KFLATID];
        self.flatNumber = dict [KFLATNUMBER];
        self.blockId = dict [KBLOCKID];
        self.blockName = dict [KBLOCKNAME];
        self.isResident = [dict [KISRECIDENT] boolValue];
        self.isOwner = [dict [KISOWNER] boolValue];
        self.residenceGroupId = dict [KRESIDENCEGROUPID];
        self.logoUrl = dict [KLOGOIMAGE];
        self.societyName = dict [KSOCIETYNAME];
        self.lastLoginSociety = dict [KLASTLOGINSOCIETY];
        self.memberLastLoginSociety = dict [KMEMBERLASTLOGINSOCIETY];
        self.name = dict [KNAME];
        self.profilePictureUrl = dict [KPROFILEPIC];
        self.email = dict [KEMAIL];
     }
    return self;
}

#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.userId = [decoder decodeObjectForKey:KUSERID];
        self.societyId = [decoder decodeObjectForKey:KSOCIETYID];
        self.isAdmin = [decoder decodeBoolForKey:KISADMIN];
        self.isMember = [decoder decodeBoolForKey:KISMEMBER];
        self.accessId = [decoder decodeObjectForKey:KACCESSID];
        self.flatId = [decoder decodeObjectForKey:KFLATID];
        self.flatNumber = [decoder decodeObjectForKey:KFLATNUMBER];
        self.blockId = [decoder decodeObjectForKey:KBLOCKID];
        self.blockName = [decoder decodeObjectForKey:KBLOCKNAME];
        self.isResident = [decoder decodeBoolForKey:KISRECIDENT];
        self.isOwner = [decoder decodeBoolForKey:KISOWNER];
        self.residenceGroupId = [decoder decodeObjectForKey:KRESIDENCEGROUPID];
        self.logoUrl = [decoder decodeObjectForKey:KLOGOIMAGE];
        self.societyName = [decoder decodeObjectForKey:KSOCIETYNAME];
        self.lastLoginSociety = [decoder decodeObjectForKey:KLASTLOGINSOCIETY];
        self.memberLastLoginSociety = [decoder decodeObjectForKey:KMEMBERLASTLOGINSOCIETY];
        self.name = [decoder decodeObjectForKey:KNAME];
        self.profilePictureUrl = [decoder decodeObjectForKey:KPROFILEPIC];
        self.email = [decoder decodeObjectForKey:KEMAILID];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_userId forKey:KUSERID];
    [coder encodeObject:_societyId forKey:KSOCIETYID];
    [coder encodeBool:_isAdmin forKey:KISADMIN];
    [coder encodeBool:_isMember forKey:KISMEMBER];
    [coder encodeObject:_accessId forKey:KACCESSID];
    [coder encodeObject:_flatId forKey:KFLATID];
    [coder encodeObject:_flatNumber forKey:KFLATNUMBER];
    [coder encodeObject:_blockId forKey:KBLOCKID];
    [coder encodeObject:_blockName forKey:KBLOCKNAME];
    [coder encodeBool:_isResident forKey:KISRECIDENT];
    [coder encodeBool:_isOwner forKey:KISOWNER];
    [coder encodeObject:_residenceGroupId forKey:KRESIDENCEGROUPID];
    [coder encodeObject:_logoUrl forKey:KLOGOIMAGE];
    [coder encodeObject:_societyName forKey:KSOCIETYNAME];
    [coder encodeObject:_lastLoginSociety  forKey:KLASTLOGINSOCIETY];
    [coder encodeObject:_memberLastLoginSociety forKey:KMEMBERLASTLOGINSOCIETY];
    [coder encodeObject:_name forKey:KNAME];
    [coder encodeObject:_profilePictureUrl forKey:KPROFILEPIC];
    [coder encodeObject:_email forKey:KEMAILID];
}
@end
