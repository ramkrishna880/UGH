//
//  TicketsTableViewCell.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 03/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Ticket;
@interface TicketsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketDateLabel;

- (void)configureTicketCellWithTicket:(Ticket *)ticket;
@end
