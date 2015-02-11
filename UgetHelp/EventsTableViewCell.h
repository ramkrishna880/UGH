//
//  EventsTableViewCell.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 02/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Event;
@interface EventsTableViewCell : UITableViewCell

- (void)configureCellwithEvent:(Event *)event;
@end
