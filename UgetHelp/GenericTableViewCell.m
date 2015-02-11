//
//  GenericTableViewCell.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 19/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "GenericTableViewCell.h"
#import "Forum.h"
#import "UIImageView+WebCache.h"
#import "WebOperations.h"
#import "NSString+Utils.h"

@implementation GenericTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (NSString *)genericCellIdentifier {
    return @"GenericTableCellIdentifier";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)forumDetailsForForum:(Forum *)forum {
    NSString *userImageUrl = [NSString stringWithFormat:@"%@/%@",API_BASE_IMAGE_URL,forum.userPhotoUrl];
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:userImageUrl] placeholderImage:nil];
    self.subjectLabel.text = forum.subject;
    self.commentsLable.text = [forum.comments stringByRemovingTabSequences];
    self.commentsCountLable.text = @(forum.commentsCount).stringValue;
    self.userNameLable.text = forum.userName;
    self.createdDateLabel.text = [self createdOnDateTostring:forum.createdOn];
    if ([forum.attachmentPath1 isEqual:[NSNull null]]) self.attachmentImageView.hidden=YES;
    
}

-(NSString *)createdOnDateTostring:(NSDate *)createdOn {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSString *createdOnString =  [NSString stringWithFormat:@"%@",createdOn];
    NSDate *createdOnDate = [formatter dateFromString:createdOnString];
    [formatter setDateFormat:@"dd'th' MMM YYYY hh:mm a"];
    NSString *dateString = [formatter stringFromDate:createdOnDate];
    return dateString;
}
@end
