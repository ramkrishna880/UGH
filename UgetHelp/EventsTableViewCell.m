//
//  EventsTableViewCell.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 02/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "EventsTableViewCell.h"
#import "Event.h"
#import "UIImageView+WebCache.h"
#import "WebOperations.h"
#import "NSString+Utils.h"

@interface EventsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLable;
@property (weak, nonatomic) IBOutlet UILabel *startTimeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImgView;

@end
@implementation EventsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellwithEvent:(Event *)event {
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",API_BASE_IMAGE_URL,event.photoUrl]] placeholderImage:PLACEHOLDER];
    self.eventNameLable.text = event.name;
    self.startTimeDateLabel.text = [self dateToString:event.fromDate];
    self.endTimeDateLabel.text = [self dateToString:event.toDate];
    self.descriptionLabel.text = [event.eventDescription stringByStrippingHTML];
    self.userNameLabel.text = [NSString stringWithFormat:@"By : %@",event.userName];
    if ([event.attachmentPath1 isEqualToString:@""]) {
        self.attachmentImgView.hidden = YES;
    }else {
        self.attachmentImgView.hidden = NO;
    }
}

-(NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateString =  [NSString stringWithFormat:@"%@",date];
    NSDate *formattedDate = [formatter dateFromString:dateString];
    [formatter setDateFormat:@"dd'th' MMM YYYY hh:mm a"];
    NSString *returnDateString = [formatter stringFromDate:formattedDate];
    return returnDateString;
}
@end
