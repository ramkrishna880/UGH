//
//  TicketInDetailsViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 03/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "TicketInDetailsViewController.h"
#import "Ticket.h"
#import "WebOperations.h"
#import "GetTicketCommentsWebOperation.h"
#import "UGHDataAccess.h"
#import "TicketsTableViewCell.h"
#import "CommentsTableViewCell.h"
#import "AddCommentsCell.h"
#import "PostImageWebOperation.h"
#import "SaveCommentWebOperation.h"
#import "NSData+StringEncodings.h"
#import "NSString+Utils.h"
#import "NSDictionary+Utils.h"

@interface TicketInDetailsViewController ()<WebOperationDelegate,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate> {
    NSMutableArray *attachmentsArray, *attachmentUrls;
}
@property (nonatomic, strong) GetTicketCommentsWebOperation *getTicketComentsWebOp;
@property (nonatomic, strong) PostImageWebOperation *postImageWebOp;
@property (nonatomic, strong) SaveCommentWebOperation *saveTicketCommentWebOp;
@property (nonatomic, strong) UGHDataAccess *dataAccess;
@property (nonatomic, strong) NSMutableArray *commentsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AddCommentsCell *addCommentCell;
@end

@implementation TicketInDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpInitialElements];
}

- (void)setUpInitialElements {
    [self.navigationController.navigationBar setTranslucent:NO];
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    [self fetchTicketsComments];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TicketsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TicketsTableViewCellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentsTableCellIdentifer"];
    [self.tableView registerClass:[AddCommentsCell class] forCellReuseIdentifier:@"AddCommentCellIdentifier"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Network Operations
- (void)fetchTicketsComments {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.getTicketComentsWebOp) {
        return;
    }
    self.getTicketComentsWebOp = [[GetTicketCommentsWebOperation alloc] initWithDelegate:self];
    self.getTicketComentsWebOp.societyId = self.dataAccess.societyId;
    self.getTicketComentsWebOp.ticketId = self.ticket.ticketId;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.getTicketComentsWebOp];
}

- (void)postImageForBytesArray:(id)bytesArray {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.postImageWebOp) {
        return;
    }
    self.addCommentCell.attachmentButton.enabled = NO;
    self.addCommentCell.saveButton.enabled = NO;
    self.postImageWebOp = [[PostImageWebOperation alloc] initWithDelegate:self];
    self.postImageWebOp.fileIndexNumber = attachmentUrls.count ? @(attachmentUrls.count).stringValue : @"1";
    self.postImageWebOp.imageBytesArray = bytesArray;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.postImageWebOp];
}

- (void)saveCommentForParameters:(NSDictionary *)dict {
    if (self.saveTicketCommentWebOp) {
        return; // web op already in progess
    }
    self.saveTicketCommentWebOp = [[SaveCommentWebOperation alloc] initWithDelegate:self];
    self.saveTicketCommentWebOp.paramDictionary = dict;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.saveTicketCommentWebOp];
}
#pragma mark - WebOperationDelegate & like
- (void)webOperationCompleted:(WebOperation *)webOp {
    if (webOp == self.getTicketComentsWebOp) {
        self.getTicketComentsWebOp = nil;
        NSMutableArray *responseArray = ((GetTicketCommentsWebOperation *)webOp).response;
        self.commentsArray = [self ticketCommentsForResponseArray:responseArray];
        [self.tableView reloadData];
    }else if (webOp == self.saveTicketCommentWebOp) {
        self.saveTicketCommentWebOp = nil;
        id response = ((SaveCommentWebOperation *)webOp).response;
        [self handleResponseAfterAddingComment:response];
    }else {
        self.postImageWebOp = nil;
        if (attachmentUrls.count<=3) {
            self.addCommentCell.attachmentButton.enabled = YES;
        }
        self.addCommentCell.saveButton.enabled = NO;
        NSString *path = ((PostImageWebOperation *)webOp).imagePath;
        if (!path)
            return;
        [attachmentUrls addObject:[path applicationImageUrlString]];
    }
}

- (void)handleResponseAfterAddingComment:(id)obj {
    if ([obj stringValue].integerValue >0) {
        self.addCommentCell.commentsTextView.text = @"";
        [attachmentsArray removeAllObjects];
        [attachmentUrls removeAllObjects];
        self.addCommentCell.attachmentButton.enabled = YES;
        [self.addCommentCell setCollectionData:nil];
        [self fetchTicketsComments];
        ShowAlert(@"", @"CommentSavedSuccessfully")
    }
}
- (NSMutableArray *)ticketCommentsForResponseArray:(NSArray *)array {
    if (!array) return nil;
    NSMutableArray *tempArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Ticket *ticket = [Ticket ticketCommentFromDictionary:(NSDictionary *)obj];
        [tempArray addObject:ticket];
    }];
    return tempArray;
}
#pragma mark TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 1;
    }else if (section == 1){
        return [self.commentsArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TicketsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketsTableViewCellIdentifier"];
        [cell configureTicketCellWithTicket:self.ticket];
        return cell;
    }else if (indexPath.section == 1) {
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsTableCellIdentifer"];
        [cell configureCellWithTicket:self.commentsArray[indexPath.row]];
        return cell;
    }else  self.addCommentCell = [tableView dequeueReusableCellWithIdentifier:@"AddCommentCellIdentifier"];
    __weak TicketInDetailsViewController *weakSelf = self;
    self.addCommentCell.saveActionBlock = ^{
        ShowAlert(@"", @"Action Block")
        NSLog(@"saveActionBlock Called.......");
        [weakSelf saveCommentInTicket];
    };
    
    self.addCommentCell.AddAttachmentBlock = ^{
        [weakSelf showActionSheet];
    };
    return self.addCommentCell;
    return nil;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 105.0f;
    }else if (indexPath.section == 1) {
        return 90.0f;
    }else if (indexPath.section == 2){
        return 202;
    }
    return 0;
}

- (void)showActionSheet {
    if (attachmentsArray.count>=3) {
        [self.addCommentCell disableAttachmentButton];
        return;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Camera", @"Photo Library",nil];
    [actionSheet showInView:self.view];
}
#pragma mark - Notifications & the like
- (void)registerForNotifications:(BOOL)shouldRegister {
    if (shouldRegister) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets;
    contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height + 50), 0.0);
    self.tableView.contentInset = contentInsets;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        UIEdgeInsets edgeInsetZero = UIEdgeInsetsZero;
        self.tableView.contentInset = edgeInsetZero;
        self.tableView.scrollIndicatorInsets = edgeInsetZero;
    }];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self addImageToAddCommentTableCellCollectionView:chosenImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    NSString *bytesArray = [imageData base64Encoding];
    [self postImageForBytesArray:bytesArray];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addImageToAddCommentTableCellCollectionView:(UIImage *)image {
    if (attachmentsArray.count==0) {
        attachmentsArray = [[NSMutableArray alloc] init];
        attachmentUrls = [[NSMutableArray alloc] init];
    }
    [attachmentsArray addObject:image];
    [self.addCommentCell setCollectionData:attachmentsArray];
}

#pragma mark Touch Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)saveCommentInTicket {
    id attachment1, attachment2, attachment3;
    attachment1 = attachmentUrls ? attachmentUrls[0] : [NSNull null];
    attachment2 = attachmentUrls.count>=2 ? attachmentUrls[1] : [NSNull null];
    attachment3 = attachmentUrls.count>=3 ? attachmentUrls[2] : [NSNull null];
    NSDictionary *commentParams = @{@"SocietyId":self.dataAccess.societyId,@"TicketId":self.ticket.ticketId,@"StatusId":@"1",@"UpdateByUserId":self.dataAccess.userId,@"Description":self.addCommentCell.commentsTextView.text,@"CreatedBy":self.dataAccess.userId,@"AttachmentPath1":attachment1,@"AttachmentPath2":attachment2,@"AttachmentPath3":attachment3};
    [self saveCommentForParameters:[commentParams dictionaryWithOutNulls]];
}

@end
