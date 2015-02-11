//
//  DetailForumViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 19/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "DetailForumViewController.h"
#import "ForumDetailsWebOperation.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"
#import "Forum.h"
#import "GenericTableViewCell.h"
#import "CommentsTableViewCell.h"
#import "AddCommentsCell.h"
#import "UIImageView+WebCache.h"
#import "SaveCommentWebOperation.h"
#import "PostImageWebOperation.h"
#import "NSString+Utils.h"
#import "NSData+StringEncodings.h"
#import "NSDictionary+Utils.h"

typedef enum : NSUInteger {
    TableCellDiscussionType = 0,
    TableCellCommentType,
    TableCellAddCommentType,
} TableCellType;

@interface DetailForumViewController ()<WebOperationDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    NSMutableArray *attachmentsArray,*attachmentUrls;
}
@property (nonatomic, strong) ForumDetailsWebOperation *forumDetailWebOp;
@property (nonatomic, strong) PostImageWebOperation *postImageWebOp;
@property (nonatomic, strong) NSString *societyId;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *forumDetails;
@property (nonatomic, strong) AddCommentsCell *addCommentCell;
@property (nonatomic, strong) SaveCommentWebOperation *saveCommentWebOp;
@property (nonatomic, strong) UGHDataAccess *dataAccess;
@end

@implementation DetailForumViewController


#pragma Mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInititialThings];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpInititialThings {
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    self.societyId = self.dataAccess.societyId;
    
    [self getForumDetails];
    [self.tableView registerNib:[UINib nibWithNibName:@"GenericTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableCellIdentifier"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentsTableCellIdentifer"];
    [self.tableView registerClass:[AddCommentsCell class] forCellReuseIdentifier:@"AddCommentCellIdentifier"];
    
    [self registerForNotifications:YES];
}

- (NSString *)stringParentClass {
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if ( index != 0 && index != NSNotFound ) {
        NSString *className = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:index-1] class]);
        return className;
    }
    //    if ([className isEqualToString:@"ForumViewController"]) {
    //        [self getForumDetails];
    //        [self.tableView registerNib:[UINib nibWithNibName:@"GenericTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableCellIdentifier"];
    //    }else if ([className isEqualToString:@"TicketsViewController"]) {
    //
    //    }els {
    //
    //    }
    return nil;
}
- (void)fetchAndRegisterCellsForRootClass {
    NSString *rootClass = [self stringParentClass];
    if ([rootClass isEqualToString:@"ForumViewController"]) {
        [self getForumDetails];
        [self.tableView registerNib:[UINib nibWithNibName:@"GenericTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TableCellIdentifier"];
    }else if ([rootClass isEqualToString:@"TicketsViewController"]) {
        
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentsTableCellIdentifer"];
    [self.tableView registerClass:[AddCommentsCell class] forCellReuseIdentifier:@"AddCommentCellIdentifier"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self registerForNotifications:NO];
}

#pragma mark Network Operations
- (void)getForumDetails {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.forumDetailWebOp) {
        return; // web op already in progess
    }
    self.forumDetailWebOp = [[ForumDetailsWebOperation alloc] initWithDelegate:self];
    self.forumDetailWebOp.societyId = self.societyId;
    self.forumDetailWebOp.forumId = self.forumId;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.forumDetailWebOp];
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
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.saveCommentWebOp) {
        return; // web op already in progess
    }
    self.saveCommentWebOp = [[SaveCommentWebOperation alloc] initWithDelegate:self];
    self.saveCommentWebOp.isForum = YES;
    self.saveCommentWebOp.paramDictionary = dict;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.saveCommentWebOp];
}
//- (void)fetchTicketsComments {
//    if (self.getTicketComentsWebOp) {
//        return;
//    }
//    self.getTicketComentsWebOp = [[GetTicketCommentsWebOperation alloc] initWithDelegate:self];
//    self.getTicketComentsWebOp.societyId = self.dataAccess.societyId;
//    self.getTicketComentsWebOp.ticketId = self.ticket.ticketId;
//    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.getTicketComentsWebOp];
//}
#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    if (webOp == self.forumDetailWebOp) {
        self.forumDetailWebOp = nil;
        NSMutableArray *responseArray = ((ForumDetailsWebOperation *)webOp).response;
        self.forumDetails = [self forumDetailsForResponseArray:responseArray];
        [self.tableView reloadData];
    }else if (webOp == self.saveCommentWebOp) {
        self.saveCommentWebOp = nil;
        id response = ((SaveCommentWebOperation *)webOp).response;
        [self handleResponseAfterAddingComment:response];
    }else {
        self.postImageWebOp = nil;
        if (attachmentUrls.count<=3) {
            self.addCommentCell.attachmentButton.enabled = YES;
        }
        self.addCommentCell.saveButton.enabled = NO;
        NSString *path = ((PostImageWebOperation *)webOp).imagePath;
        if (!path) {
            return;
        }
        [attachmentUrls addObject:[path applicationImageUrlString]];
    }
}
//- (void)webOperationCompleted:(WebOperation *)webOp {
//    self.getTicketComentsWebOp = nil;
//    NSMutableArray *responseArray = ((GetTicketCommentsWebOperation *)webOp).response;
//    self.commentsArray = [self ticketCommentsForResponseArray:responseArray];
//    [self.tableView reloadData];
//}
//
//- (NSMutableArray *)ticketCommentsForResponseArray:(NSArray *)array {
//    if (!array) return nil;
//    NSMutableArray *tempArray = [NSMutableArray new];
//    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        Ticket *ticket = [Ticket ticketCommentFromDictionary:(NSDictionary *)obj];
//        [tempArray addObject:ticket];
//    }];
//    return tempArray;
//}
- (NSMutableArray *)forumDetailsForResponseArray:(NSMutableArray *)array {
    if (!array) return nil;
    NSMutableArray *tempArray = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Forum *forum = [Forum forumFromDictionary:(NSDictionary *)obj];
        [tempArray addObject:forum];
    }];
    return tempArray;
}

- (void)handleResponseAfterAddingComment:(id)response {
    if ([response stringValue].integerValue >0) {
        self.addCommentCell.commentsTextView.text = @"";
        [attachmentsArray removeAllObjects];
        [attachmentUrls removeAllObjects];
        [self.addCommentCell setCollectionData:nil];
        self.addCommentCell.attachmentButton.enabled = YES;
        [self getForumDetails];
        ShowAlert(@"Forum", @"Saved successfully")
    }
}
#pragma mark - TableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == TableCellDiscussionType || section == TableCellAddCommentType) {
        return 1;
    }else {
        return self.forumDetails.count-1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > TableCellAddCommentType) {
        return nil;
    }
    if (indexPath.section == TableCellDiscussionType) {
        GenericTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifier"];
        Forum *forum = self.forumDetails [indexPath.row];
        [cell forumDetailsForForum:forum];
        return cell;
    } else if (indexPath.section == TableCellCommentType) {
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsTableCellIdentifer"];
        [cell configureCellWithForumDetails:(Forum *) self.forumDetails[indexPath.row+1]];
        return cell;
    }else {
        self.addCommentCell = [tableView dequeueReusableCellWithIdentifier:@"AddCommentCellIdentifier"];
        __weak DetailForumViewController *weakSelf = self;
        self.addCommentCell.saveActionBlock = ^{
            [weakSelf saveCommentForForum];
        };
        
        self.addCommentCell.AddAttachmentBlock = ^{
            [weakSelf showActionSheet];
        };
        return self.addCommentCell;
    }
    return nil;
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
#pragma mark TableView Delegate
// height needed to change when we mix both forum and tickets
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableCellDiscussionType) {
        return 135;
    }else if (indexPath.section == TableCellCommentType) {
        return 90;
    }else {
        return 202;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:TableCellAddCommentType] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    NSString *bytesArray = [imageData base64Encoded];
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

- (void)saveCommentForForum {
    id attachment1, attachment2, attachment3;
    attachment1 = attachmentUrls ? attachmentUrls[0] : [NSNull null];
    attachment2 = attachmentUrls.count>=2 ? attachmentUrls[1] : [NSNull null];
    attachment3 = attachmentUrls.count>=3 ? attachmentUrls[2] : [NSNull null];
    NSDictionary *params = @{@"ForumId":self.forumId,@"UserId":self.dataAccess.userId,@"Comments":self.addCommentCell.commentsTextView.text,@"CreatedBy":self.dataAccess.userId,@"AttachmentPath1":attachment1,@"AttachmentPath2":attachment2,@"AttachmentPath3":attachment3};
    [self saveCommentForParameters:[params dictionaryWithOutNulls]];
}


#pragma mark Touch Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
