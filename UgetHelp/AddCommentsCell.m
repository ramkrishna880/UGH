//
//  AddCommentsCell.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 28/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "AddCommentsCell.h"
#import "ContainerCellView.h"
#import "UIView+Borders.h"

#define FONT_SIZE 13.0f
#define MINDIST 2.0f
#define COLLECTIONCELLWIDTH 60.0f

@interface AddCommentsCell ()<UIActionSheetDelegate>{
    BOOL isCollectionPresent;
}
@property (strong, nonatomic) ContainerCellView *collectionView;
@property (nonatomic, strong) UILabel *attachmentsLbl;
@end
@implementation AddCommentsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpElementsAndCollectionView];
    }
    return self;
}
- (void)setUpElementsAndCollectionView {
    self.commentsTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+5, 304, 55)];
    [self.commentsTextView setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [self.commentsTextView setTextAlignment:NSTextAlignmentLeft];
    [self.commentsTextView setTextColor:[UIColor blackColor]];
//    [self.commentsTextView setText:@"Comments"];
    [self.commentsTextView applyBorderForWidth:2 andRadius:10];
    self.commentsTextView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:self.commentsTextView];
    
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(inputAccessoryViewDidFinish)];
    [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
    self.commentsTextView.inputAccessoryView = myToolbar;
    
    self.attachmentsLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.commentsTextView.frame.origin.x, self.commentsTextView.frame.origin.y+self.commentsTextView.frame.size.height+2*MINDIST, 102, 20)];
    self.attachmentsLbl.font = [UIFont systemFontOfSize:FONT_SIZE];
    self.attachmentsLbl.text = @"Attachments";
    self.attachmentsLbl.textColor = [UIColor blackColor];
    self.attachmentsLbl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.contentView addSubview:self.attachmentsLbl];
    
    self.attachmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.attachmentButton setFrame:CGRectMake(self.attachmentsLbl.frame.origin.x+self.attachmentsLbl.frame.size.width+2*MINDIST, self.attachmentsLbl.frame.origin.y, 20, 20)];
    [self.attachmentButton setImage:[UIImage imageNamed:@"attach"] forState:UIControlStateNormal];
    [self.attachmentButton addTarget:self action:@selector(addAttachmentsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.attachmentButton];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setFrame:CGRectMake((self.bounds.size.width/2)- 113, self.attachmentButton.frame.origin.y+self.attachmentButton.frame.size.height+2*MINDIST, 225, 25)];
    [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setBackgroundColor:[UIColor blackColor]];
    [self.saveButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.saveButton.layer setCornerRadius:5.0f];
    [self.saveButton.layer setMasksToBounds:YES];
    [self.contentView addSubview:self.saveButton];
    
    self.collectionView = [[NSBundle mainBundle] loadNibNamed:@"ContainerCellView" owner:self options:nil][0];
    self.collectionView.frame = CGRectMake(10, self.attachmentButton.frame.origin.y+self.attachmentButton.frame.size.height+2*MINDIST, 300, COLLECTIONCELLWIDTH);
    [self.contentView addSubview:_collectionView];
    
    self.saveButton.frame = CGRectMake((self.bounds.size.width/2)- 113, self.collectionView.frame.origin.y+COLLECTIONCELLWIDTH+4*MINDIST, 225, 25);
    //[self registerForNotifications:YES];
   
}

- (void)registerForNotifications:(BOOL)shouldRegister {
    if (shouldRegister) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myTextViewDidBegin)
                                                     name:UITextViewTextDidBeginEditingNotification
                                                   object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myTextViewDidEnd)
                                                     name:UITextViewTextDidEndEditingNotification
                                                   object:self];
    }else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void)dealloc {
    [self registerForNotifications:NO];
}
- (void)SetIsCollectionView:(BOOL)addCollectionView {
    if (!addCollectionView) {
        isCollectionPresent = NO;
        return;
    }
    isCollectionPresent = addCollectionView;
}

- (void)setCollectionData:(NSArray *)collectionData {
    [_collectionView setCollectionData:collectionData];
}

#pragma Mark UITextViewDelegate
- (void)myTextViewDidBegin {
    if ([self.commentsTextView.text isEqualToString:@"Comments"]) {
        self.commentsTextView.text = @"";
        self.commentsTextView.textColor = [UIColor blackColor]; //optional
    }
    [self.commentsTextView becomeFirstResponder];
}

- (void)myTextViewDidEnd {
    if ([self.commentsTextView.text isEqualToString:@""]) {
        self.commentsTextView.text = @"Comments";
        self.commentsTextView.textColor = [UIColor lightGrayColor]; //optional
    }
    [self.commentsTextView resignFirstResponder];
}

#pragma Mark Button Actions
- (void)saveButtonClicked:(id)sender {
    if (self.saveActionBlock) {
        self.saveActionBlock();
    }
}
- (void)addAttachmentsButtonTapped:(id)sender {
    //    [self addcollectionViewInTableViewCell];
    if (self.AddAttachmentBlock) {
        self.AddAttachmentBlock();
    }
}

- (void)disableAttachmentButton {
    [self.attachmentButton setUserInteractionEnabled:NO];
}

- (NSString *)commentsText {
    if ([self.commentsTextView.text isEqualToString:@"Comments"]) {
        return @"";
    }
    return self.commentsTextView.text;
}

- (void)inputAccessoryViewDidFinish {
    [self.commentsTextView resignFirstResponder];
}
@end
