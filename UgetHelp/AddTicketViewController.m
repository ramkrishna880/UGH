//
//  AddTicketViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 05/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "AddTicketViewController.h"
#import "RadioButton.h"
#import "ContainerCellView.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"
#import "CreateForumOrTicketWebOp.h"
#import "PostImageWebOperation.h"
#import "NSString+Utils.h"
#import "UIView+Borders.h"
#import "NSDictionary+Utils.h"
#import "NSData+StringEncodings.h"
#import "UGHDataAccess.h"
#import "User.h"

//#define COLLECTION_FRAME   CGRectMake(10, 342, 300, 60)
//#define BUTTON_FRAME  CGRectMake(40, 419, 240, 30)

@interface AddTicketViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate,WebOperationDelegate> {
    BOOL isCollectionAdded;
    NSMutableArray *attachmentsArray,*attachmentUrls;
    NSString *categoryId,*issueType,*ticketProirity;
}
@property (nonatomic, strong) CreateForumOrTicketWebOp *createTicketWebOp;
@property (strong, nonatomic) PostImageWebOperation *postImageWebOp;
@property (nonatomic, strong)ContainerCellView *collectionView;
@property (nonatomic, strong) UIPickerView *categoryPickerView;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet RadioButton *issueTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *attachmentButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) UGHDataAccess *dataAccess;
- (IBAction)attachmentsAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)prioritySelected:(RadioButton *)sender;
- (IBAction)issueTypeSelected:(RadioButton *)sender;

@end
@implementation AddTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    attachmentUrls = [[NSMutableArray alloc] init];
    [self setUpInitialElements];
}
- (void)setUpInitialElements {
    self.title = @"Add Ticket";
    isCollectionAdded = NO;
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    [self.descriptionTextView applyBorderForWidth:1.0 andRadius:10];
    issueType = ticketProirity = @"1";
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    [self performRequest];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Network operations
- (void)createTicketForParameters:(NSDictionary *)dict {
    if (!self.dataAccess.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.createTicketWebOp) {
        return;
    }
    self.createTicketWebOp = [[CreateForumOrTicketWebOp alloc] initWithDelegate:self];
    self.createTicketWebOp.isForum = NO;
    self.createTicketWebOp.bodyDictionary = dict;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.createTicketWebOp];
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
    if (webOp == self.createTicketWebOp) {
        self.createTicketWebOp = nil;
        id response = ((CreateForumOrTicketWebOp *)webOp).response;
        [self handleResponseForAddTicket:response];
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

- (void)handleResponseForAddTicket:(id)response {
    if (!response) {
        ShowAlert(@"", @"Unknown Response")
        return;
    }
    if ([[response stringValue] integerValue] >0) {
        self.subjectTextField.text = @"";
        self.descriptionTextView.text = @"";
        [attachmentsArray removeAllObjects];
        [attachmentUrls removeAllObjects];
        [self.collectionView setCollectionData:attachmentsArray];
        ShowAlert(@"Ticket", @"Added Successfully")
    }
}
#pragma mark Actions
- (IBAction)attachmentsAction:(id)sender {
    [self showActionSheet];
}

- (IBAction)saveAction:(id)sender {
    User *user = [self.dataAccess selectedUser];  //handle better issueType , ticketPrority
    //Handle Better
    id attachment1, attachment2, attachment3;
    attachment1 = attachmentUrls ? attachmentUrls[0] : [NSNull null];
    attachment2 = attachmentUrls.count>=2 ? attachmentUrls[1] : [NSNull null];
    attachment3 = attachmentUrls.count>=3 ? attachmentUrls[2] : [NSNull null];
    NSDictionary *ticketsParams = @{@"DId":@"0",@"SocietyId":user.societyId,@"CategoryId":categoryId,@"IssueType":issueType,@"RaisedUserId":user.userId,@"TicketDate":[self changeDateToDateString:[NSDate date]],@"Subject":self.subjectTextField.text,@"Description":self.descriptionTextView.text,@"AssignedToUserId":@"0",@"StatusId":@"1",@"BlockId":user.blockId,@"FlatId":user.flatId,@"TicketPriority":ticketProirity,@"Rating":@"1",@"CreatedBy":user.userId,@"UpdatedBY":user.userId,@"AttachmentPath1":attachment1,@"AttachmentPath2":attachment2,@"AttachmentPath3":attachment3};
    [self createTicketForParameters:[ticketsParams dictionaryWithOutNulls]];
}
- (NSString *) changeDateToDateString :(NSDate *) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd HH:mm:ss" options:0 locale:locale];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:locale];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (IBAction)prioritySelected:(RadioButton *)sender {
    ticketProirity = [@(sender.tag) stringValue];
}

- (IBAction)issueTypeSelected:(RadioButton *)sender {
    issueType = [@(sender.tag) stringValue];
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Actionsheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self addCollectionView];
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
    [self.collectionView setCollectionData:attachmentsArray];
}

- (void)pickerView {
    self.categoryPickerView = [[UIPickerView alloc] init];
    self.categoryPickerView.delegate = self;
    self.categoryPickerView.dataSource = self;
    self.categoryTextField.inputView = self.categoryPickerView;
    
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, 320, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(inputAccessoryViewDidFinish)];
    [myToolbar setItems:[NSArray arrayWithObject: doneButton] animated:NO];
    self.categoryTextField.inputAccessoryView = myToolbar;
}
- (void)inputAccessoryViewDidFinish {
    [self.categoryTextField resignFirstResponder];
}

#pragma mark TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.categoryTextField) {
        [self pickerView];
    }
}

#pragma mark PickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.categories.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = [self.categories [row] valueForKey:@"CategoryName"];
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *str = [self.categories [row] valueForKey:@"CategoryName"];
    categoryId = [self.categories [row] valueForKey:@"CategoryId"];
    self.categoryTextField.text = str;
}

- (void)performRequest {
    UGHDataAccess *dataAccess = [UGHDataAccess sharedDataAccess];
    NSString *strURL= [NSString stringWithFormat:@"%@/TicketsAPI/GetCategories?societyId=%@",API_MEMBER_URL,dataAccess.societyId];
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *requestURL = [[NSMutableURLRequest alloc] initWithURL:URL];
    requestURL.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         id responseObject = [self deserializeData:data];
         self.categories = [[NSMutableArray alloc] initWithArray:responseObject];
         [self.categoryPickerView reloadAllComponents];
     }];
}

- (NSArray *)deserializeData:(NSData *)data {
    NSError *error = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        ShowAlert(@"", error.localizedDescription);
        return nil;
    }
    if (![responseObject isKindOfClass:[NSArray class]]) {
        ShowAlert(@"",@"Un Expected Response");
        return nil;
    }
    
    return responseObject;
}

- (BOOL)isEdited {
    if (self.categoryTextField.text || self.subjectTextField.text || self.descriptionTextView.text || isCollectionAdded) {
        return YES;
    }
    return NO;
}
@end

