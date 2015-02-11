//
//  TicketsTableViewCell.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 03/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "TicketsTableViewCell.h"
#import "Ticket.h"

typedef enum : NSUInteger {
    TicketStatusOpen = 1,
    TicketStatusInProgress,
    TicketStatusHold,
    TicketStatusCompleted,
    TicketStatusClosed,
}TicketStatus;

typedef enum : NSUInteger {
    TicketProirityNormal = 1,
    TicketProirityHigh,
    TicketProirityUrgent,
} TicketProirity;

typedef enum : NSUInteger {
    IssueTypePersonal = 1,
    IssueTypeCommon,
} IssueType;

@interface TicketsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *ticketStatusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ticketPriorityImageView;
@property (weak, nonatomic) IBOutlet UIImageView *issueTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImageView;
@end
@implementation TicketsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureTicketCellWithTicket:(Ticket *)ticket {
    self.ticketStatusImageView.image = [self ticketStatusImage:ticket.statusId];
    self.ticketPriorityImageView.image = [self ticketPriorityImage:ticket.ticketPriority];
    self.issueTypeImageView.image = [self issueTypeImage:ticket.issueType];
    self.categoryNameLabel.text = ticket.categoryName;
    self.subjectLabel.text = ticket.subject;
    self.DescriptionLabel.text = ticket.ticketDescription;
    self.nameLabel.text = ticket.name;
    self.ticketDateLabel.text = [self dateTostring:ticket.ticketDate];
    if ([ticket.attachmentPath1 isEqual:[NSNull null]]) self.attachmentImageView.hidden=YES;
}

- (UIImage *)ticketStatusImage:(NSString *)statusId {
    NSUInteger status = [statusId integerValue];
    switch (status) {
        case TicketStatusOpen:
            return [UIImage imageNamed:@"ticket_status_open"];
            break;
        case TicketStatusInProgress:
            return [UIImage imageNamed:@"ticket_status_progress"];
            break;
        case TicketStatusHold:
            return [UIImage imageNamed:@"ticket_Status_Hold"];
            break;
        case TicketStatusCompleted:
            return [UIImage imageNamed:@"ticket_status_completed"];
            break;
        case TicketStatusClosed:
            return [UIImage imageNamed:@"ticket_status_closed"];
            break;
        default:
            return nil;
            break;
    }
}

- (UIImage *)ticketPriorityImage:(NSString *)ticketPriority {
    NSUInteger priority = [ticketPriority integerValue];
    switch (priority) {
        case TicketProirityNormal:
            return [UIImage imageNamed:@"ticket_Normal_priority"];
            break;
        case TicketProirityHigh:
            return [UIImage imageNamed:@"ticket_high_priority"];
            break;
        case TicketProirityUrgent:
            return [UIImage imageNamed:@"ticket_urgent_priority"];
            break;
        default:
            return nil;
            break;
    }
}

- (UIImage *)issueTypeImage:(NSString *)issueTyp {
    NSUInteger issue = [issueTyp integerValue];
    switch (issue) {
        case IssueTypePersonal:
            return [UIImage imageNamed:@"ticket_type_personal"];
            break;
        case IssueTypeCommon:
            return [UIImage imageNamed:@"ticket_type_common"];
            break;
        default:
            return nil;
            break;
    }
}
-(NSString *)dateTostring:(NSDate *)ticketDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSString *ticketDateString =  [NSString stringWithFormat:@"%@",ticketDate];
    NSDate *convertedTicketDate = [formatter dateFromString:ticketDateString];
    [formatter setDateFormat:@"dd'th' MMM YYYY hh:mm a"];
    NSString *dateString = [formatter stringFromDate:convertedTicketDate];
    return dateString;
}
@end
