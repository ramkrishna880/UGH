//
//  SidebarViewController.h
//  UgetHelp
//
//  Created by A3it on 12/10/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
