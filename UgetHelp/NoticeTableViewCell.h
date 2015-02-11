//
//  NoticeTableViewCell.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 23/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Notice;

@interface NoticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentsLable;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedOnDateLable;

- (void)configureCellWithNoticeDetails:(Notice *)notice;
@end
