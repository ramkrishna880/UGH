//
//  Constants.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 07/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#ifndef UgetHelp_Constants_h
#define UgetHelp_Constants_h


#define Stringify(x) x ? [x description] : @""
#define StringifyMoney(value) [NSString stringWithFormat:@"%.2f", value]
#define ShowAlert(x, y) [[[UIAlertView alloc] initWithTitle:x message:y delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
#define ShowFixMeAlert(x) ShowAlert(@"FIX ME", x)
#define NilIfEmptyString(x) [x length] ? x : nil
#define NilIfNSNull(x) x == [NSNull null] ? nil : x
#define NSNullIfNil(x) x ?: [NSNull null]
#define appDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define IS_OS_8_OR_LATER (IOS_VERSION >= 8.0)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define PLACEHOLDER [UIImage imageNamed:@"placeholderImage"]

static NSString * const USER_INFO_KEY = @"user_information";
static NSString * const KERROR_MSG_KEY = @"ErrorMessage";

static NSString * const KEMAIL = @"Email";
static NSString * const KPASSWORD = @"Password";

#define MINIMUMDIST 10.0f
#endif
