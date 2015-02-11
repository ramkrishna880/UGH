//
//  NoticeTableViewCell.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 23/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import "Notice.h"
#import "UIImageView+WebCache.h"
#import "WebOperations.h"
#import "NSString+Utils.h"


@implementation NoticeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureCellWithNoticeDetails:(Notice *)notice {
    NSString *userImageUrl = [NSString stringWithFormat:@"%@/%@",API_BASE_IMAGE_URL,notice.userPhotoUrl];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:PLACEHOLDER];
    self.subjectLabel.text = notice.subject;
    self.commentsLable.text = [notice.noticeDescription stringByStrippingHTML];
    self.userNameLable.text = notice.userName;
    self.createdDateLabel.text = [self createdOnDateTostring:notice.createdOn];
    self.updatedOnDateLable.text = [self createdOnDateTostring:notice.updatedOn];
    if ([notice.attachmentPath1 isEqual:[NSNull null]]) self.attachmentImageView.hidden=YES;
}

-(NSString *)createdOnDateTostring:(NSDate *)createdOn {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
    NSString *createdOnString =  [NSString stringWithFormat:@"%@",createdOn];
    NSDate *createdOnDate = [formatter dateFromString:createdOnString];
    [formatter setDateFormat:@"dd'th' MMM YYYY hh:mm a"];
    NSString *dateString = [formatter stringFromDate:createdOnDate];
    return dateString;
}
@end
