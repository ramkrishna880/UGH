//
//  WebOperations.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 07/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#ifndef UgetHelp_WebOperations_h
#define UgetHelp_WebOperations_h

#ifndef API_BASE_URL
//#define API_BASE_URL @"http://192.168.10.7/uGetHelpAdminAPI/api"  // for development
#define API_BASE_URL @"http://www.ugethelp.com/AdminAPI/api"
#endif

#ifndef API_BASE_IMAGE_URL
#define API_BASE_IMAGE_URL @"http://www.ugethelp.com"
#endif


#ifndef API_MEMBER_URL
//#define API_MEMBER_URL @"http://192.168.10.7/uGethelpMemberAPI/api"
#define API_MEMBER_URL @"http://www.ugethelp.com/MemberAPI/api"
#endif

#define ERROR_DOMAIN  @"com.tag.UGH"
#define DEFAULT_TIMEOUT_INTERVAL 60.0f

#import "NSError+Utils.h"

#import "WebOperation.h"
#import "WebOperationQueue.h"

#import "LoginWebOperation.h"
#import "EventsWebOperation.h"
#import "NoticesWebOperation.h"
#import "ForumsWebOperation.h"
#import "UserProfileWebOperation.h"
#import "SaveUserProfileWebOperation.h"
#endif
