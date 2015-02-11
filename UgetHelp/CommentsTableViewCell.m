//
//  CommentsTableViewCell.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 21/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "Forum.h"
#import "Ticket.h"
#import "UIImageView+WebCache.h"
#import "WebOperations.h"


@implementation CommentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithForumDetails:(Forum *)forum {
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",API_BASE_IMAGE_URL,forum.userPhotoUrl]] placeholderImage:nil];
    self.userName.text = forum.userName;
    self.dateLabel.text = [self dateTostring:forum.createdOn];
    self.comments.text = forum.comments;
    if ([forum.attachmentPath1 isEqual:[NSNull null]]) self.attachmentImage.hidden=YES;
}

-(NSString *)dateTostring:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSString *dateStr =  [NSString stringWithFormat:@"%@",date];
    NSDate *parsedDate = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"dd'th' MMM YYYY hh:mm a"];
    NSString *dateString = [formatter stringFromDate:parsedDate];
    return dateString;
}

- (void)configureCellWithTicket:(Ticket *)ticket {
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",API_BASE_IMAGE_URL,ticket.photoUrl]] placeholderImage:nil];
    self.userName.text = ticket.name;
    self.comments.text = ticket.ticketDescription;
    self.dateLabel.text = [self dateTostring:ticket.updatedDate];
}
@end
