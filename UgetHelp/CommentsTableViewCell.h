//
//  CommentsTableViewCell.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 21/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Forum,Ticket;

@interface CommentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImage;
@property (weak, nonatomic) IBOutlet UILabel *comments;

-(void)configureCellWithForumDetails:(Forum *)forum;
- (void)configureCellWithTicket:(Ticket *)ticket;
@end
