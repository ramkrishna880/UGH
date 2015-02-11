//
//  NoticesInDetailViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 23/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "NoticesInDetailViewController.h"
#import "ContainerCellView.h"
#import "Notice.h"
#import "Event.h"
#import "NSString+Utils.h"
#import "UIView+Borders.h"

@interface NoticesInDetailViewController () {
    
    __weak IBOutlet UILabel *attachmentLbl;
    __weak IBOutlet UIView *attachView;
}
@property (weak, nonatomic) IBOutlet UILabel *bodyResizableLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *createdOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (strong, nonatomic) ContainerCellView *collectionView;
@end

@implementation NoticesInDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInitialThings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpInitialThings {
    attachmentLbl.hidden = YES;
    [self addCollectionView];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    if (self.isNotice) {
        [self configureViewWithNotice];
    }else {
        [self configureViewWithEvent];
    }
    CGSize contentSize = self.scrollView.contentSize;
    if (self.bodyResizableLabel.bounds.size.height > contentSize.height) {
        contentSize.height = self.bodyResizableLabel.bounds.size.height;
        self.scrollView.contentSize = contentSize;
    }
    [self checkAttachments];
}

- (void)configureViewWithNotice {
    Notice *notice = self.obj;
    self.userNameLable.text = notice.userName;
    self.createdOnLabel.text = [self createdOnDateTostring:notice.createdOn];
    self.subjectLabel.text = [NSString stringWithFormat:@"Subject: %@",notice.subject];
    NSString *labelText = [NSString stringWithFormat:@"%@ \n \n warm regards \n%@",[notice.noticeDescription stringByStrippingHTML],notice.userName];
    [self changeLabelHeightForText:labelText];
    self.bodyResizableLabel.text = labelText;
}
- (void)configureViewWithEvent {
    Event *event = self.obj;
    self.userNameLable.text = event.userName;
    self.createdOnLabel.text = [self createdOnDateTostring:event.createdOn];
    self.subjectLabel.text = [NSString stringWithFormat:@"Subject: %@",event.name];
    NSString *labelText = [NSString stringWithFormat:@"%@ \n \nwarm regards \n%@",[event.eventDescription stringByStrippingHTML],event.userName];
    [self changeLabelHeightForText:labelText];
    self.bodyResizableLabel.text = labelText;
}
- (void)addCollectionView {
    [attachView applyBorderForWidth:1.0 andRadius:0];
    self.collectionView = [[NSBundle mainBundle] loadNibNamed:@"ContainerCellView" owner:self options:nil][0];
    self.collectionView.frame = CGRectMake(10, 1, 300, 60);
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [attachView addSubview:_collectionView];
}

- (void)changeLabelHeightForText:(NSString *)text {
    CGSize constrainedSize = CGSizeMake(self.bodyResizableLabel.frame.size.width  , 9000);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys: [UIFont systemFontOfSize:13.0f], NSFontAttributeName, nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (requiredHeight.size.width > self.bodyResizableLabel.frame.size.width) {
        requiredHeight = CGRectMake(0,0, self.bodyResizableLabel.frame.size.width, requiredHeight.size.height);
    }
    CGRect newFrame = self.bodyResizableLabel.frame;
    newFrame.size.height = requiredHeight.size.height;
    self.bodyResizableLabel.frame = newFrame;
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

- (void)checkAttachments {
    NSMutableArray *attachments = [[NSMutableArray alloc] init];
    if (self.isNotice) {
        Notice *notice = self.obj;
        if (![notice.attachmentPath1 isEqualToString:@""]) {
            attachmentLbl.hidden = NO;
            self.collectionView.hidden = NO;
            if (![notice.attachmentPath1 isEqualToString:@""]) [attachments addObject:notice.attachmentPath1];
            if (![notice.attachmentPath2 isEqualToString:@""]) [attachments addObject:notice.attachmentPath2];
            if (![notice.attachmentPath3 isEqualToString:@""]) [attachments addObject:notice.attachmentPath3];
            [self.collectionView setCollectionData:attachments];
        }else{
            attachmentLbl.hidden = YES;
            self.collectionView.hidden = YES;
        }
    }else {
        Event *event = self.obj;
        //        NSArray *ext = @[@"jpj",@"png",@"jpeg"];
        //        [event.attachmentPath1 pathExtension]
        if (![event.attachmentPath1 isEqualToString:@""] ) {
            attachmentLbl.hidden = NO;
            self.collectionView.hidden = NO;
            if (![event.attachmentPath1 isEqualToString:@""]) [attachments addObject:event.attachmentPath1];
            if (![event.attachmentPath2 isEqualToString:@""]) [attachments addObject:event.attachmentPath2];
            if (![event.attachmentPath3 isEqualToString:@""]) [attachments addObject:event.attachmentPath3];
            [self.collectionView setCollectionData:attachments];
        }else{
            attachmentLbl.hidden = YES;
            self.collectionView.hidden = YES;
        }
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//    self.userNameLable.text = self.notice.userName;
//    self.createdOnLabel.text = [self createdOnDateTostring:self.notice.createdOn];
//    self.subjectLabel.text = [NSString stringWithFormat:@"Subject: %@",self.notice.subject];
//    NSString *labelText = [NSString stringWithFormat:@"%@ \n \n warm regards \n%@",[self.notice.noticeDescription stringByRemovingTagsAndAppendingTabs],self.notice.userName];
//    [self changeLabelHeightForText:labelText];
//    self.bodyResizableLabel.text = labelText;
@end
