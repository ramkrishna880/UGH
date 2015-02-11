//
//  DetailForumViewController.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 19/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailForumViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *forumId;
//@property (nonatomic, strong) NSString *classIdentifier;
@end
