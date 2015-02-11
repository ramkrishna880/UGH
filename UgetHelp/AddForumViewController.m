//
//  AddForumViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 05/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "AddForumViewController.h"
#import "ContainerCellView.h"
#import "UIView+Borders.h"
#import "CreateForumOrTicketWebOp.h"
#import "PostImageWebOperation.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"
#import "NSData+StringEncodings.h"
#import "NSString+Utils.h"
#import "NSDictionary+Utils.h"

#define COLLECTION_FRAME   CGRectMake(10, 259, 300, 60)
#define BUTTON_FRAME  CGRectMake(40, 335, 240, 30)

@interface AddForumViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate,WebOperationDelegate> {
    BOOL isCollectionAdded;
    NSMutableArray *attachmentsArray,*attachmentUrls;
    
}
@property (nonatomic, strong) ContainerCellView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) CreateForumOrTicketWebOp *createForumWebOp;
@property (strong, nonatomic) PostImageWebOperation *postImageWebOp;
@property (strong, nonatomic) UGHDataAccess *dataAccess;
- (IBAction)addAttachmentTapped:(id)sender;
- (IBAction)createForum:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *attachmentButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation AddForumViewController


#pragma mark View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    attachmentUrls = [[NSMutableArray alloc] init];
    [self setUpInitialElements];
}

- (void)setUpInitialElements {
    self.title = @"Add Forum";
    isCollectionAdded = NO;
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.commentsTextView applyBorderForWidth:1.0f andRadius:10.0f];
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Network operations
- (void)createForumForParameters:(NSDictionary *)dict {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.createForumWebOp) {
        return;
    }
    self.createForumWebOp = [[CreateForumOrTicketWebOp alloc] initWithDelegate:self];
    self.createForumWebOp.isForum = YES;
    self.createForumWebOp.bodyDictionary = dict;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.createForumWebOp];
}

- (void)postImageForBytesArray:(id)bytesArray {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.postImageWebOp) {
        return;
    }
    [self.attachmentButton setEnabled:NO];
    self.postImageWebOp = [[PostImageWebOperation alloc] initWithDelegate:self];
    self.postImageWebOp.fileIndexNumber = attachmentUrls.count ? @(attachmentUrls.count).stringValue : @"1";
    self.postImageWebOp.imageBytesArray = bytesArray;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.postImageWebOp];
}

#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    if (webOp == self.createForumWebOp) {
        self.createForumWebOp = nil;
        id response = ((CreateForumOrTicketWebOp *)webOp).response;
        [self handleResponseForAddForum:response];
    }else {
        self.postImageWebOp = nil;
        if (attachmentsArray.count<3) [self.attachmentButton setEnabled:YES];
        NSString *path = ((PostImageWebOperation *)webOp).imagePath;
        if (!path) {
            return;
        }
        [attachmentUrls addObject:[path applicationImageUrlString]];
        [self.collectionView setCollectionData:attachmentsArray];
    }
}

- (void)handleResponseForAddForum:(id)response {
    if (!response) {
        ShowAlert(@"", @"Unknown Response")
        return;
    }
    if ([response stringValue].integerValue >0 ) {
        self.subjectTextField.text = @"";
        self.commentsTextView.text = @"";
        [attachmentsArray removeAllObjects];
        [attachmentUrls removeAllObjects];
        self.attachmentButton.enabled = YES;
        [self.collectionView setCollectionData:attachmentsArray];
        ShowAlert(@"Forum", @"Added Successfully")
    }
}
#pragma mark Actions
- (IBAction)addAttachmentTapped:(id)sender {
    [self showActionSheet];
}

- (IBAction)createForum:(id)sender {
    //Handle Better
    id attachment1, attachment2, attachment3;
    attachment1 = attachmentUrls ? attachmentUrls[0] : [NSNull null];
    attachment2 = attachmentUrls.count>=2 ? attachmentUrls[1] : [NSNull null];
    attachment3 = attachmentUrls.count>=3 ? attachmentUrls[2] : [NSNull null];
    NSDictionary *forumParams = @{@"Comments":self.commentsTextView.text,@"ForumType":@"1",@"IsActive":@"1",@"Subject":self.subjectTextField.text,@"ForumId":@"0",@"CreatedBy":self.dataAccess.userId,@"UpdatedBy":self.dataAccess.userId,@"CommentsCount":@"0",@"UserId":self.dataAccess.userId,@"SocietyId":self.dataAccess.societyId,@"AttachmentPath1":attachment1,@"AttachmentPath2":attachment2,@"AttachmentPath3":attachment3};
    [self createForumForParameters:[forumParams dictionaryWithOutNulls]];
}


- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self loadFromCamera];
            break;
        case 1:
            [self loadFromPhotoLibrary];
            break;
            
        default:
            break;
    }
}

- (void)loadFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
- (void)loadFromPhotoLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self addCollectionView];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    NSString *bytesArray = [imageData base64Encoded];
    [self postImageForBytesArray:bytesArray];
    [self addImageToCollectionView:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark misc & like
- (void)addCollectionView {
    if (isCollectionAdded) {
        return;
    }
    isCollectionAdded = YES;
    self.collectionView = [[NSBundle mainBundle] loadNibNamed:@"ContainerCellView" owner:self options:nil][0];
    self.collectionView.frame = CGRectMake(10, self.attachmentButton.frame.origin.y+self.attachmentButton.frame.size.height+MINIMUMDIST, 300, 60);
    [self.view addSubview:_collectionView];
    CGRect frame = self.saveButton.frame;
    frame.origin.y = self.collectionView.frame.origin.y + self.collectionView.frame.size.height+MINIMUMDIST;
    self.saveButton.frame = frame;
}

- (void)showActionSheet {
    if (attachmentsArray.count>=3) {
        self.attachmentButton.enabled = NO;
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Camera", @"Photo Library",nil];
    [actionSheet showInView:self.view];
}
- (void)addImageToCollectionView:(UIImage *)image {
    if (attachmentsArray.count==0) {
        attachmentsArray = [[NSMutableArray alloc] init];
    }
    [attachmentsArray addObject:image];
}
- (BOOL)isViewEdited {
    if (self.subjectTextField.text || self.commentsTextView.text || isCollectionAdded) {
        return YES;
    }
    return NO;
}

@end
