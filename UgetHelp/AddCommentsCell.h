//
//  AddCommentsCell.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 28/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommentsCell : UITableViewCell

@property (nonatomic, strong) UITextView *commentsTextView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *attachmentButton;


@property (nonatomic, copy) void (^saveActionBlock)(void);
@property (nonatomic, copy) void (^AddAttachmentBlock)(void);

- (void)setCollectionData:(NSArray *)collectionData;
- (void)disableAttachmentButton;
- (NSString *)commentsText;

//- (void)addcollectionViewInTableViewCell;
- (void)SetIsCollectionView:(BOOL)addCollectionView;
@end
