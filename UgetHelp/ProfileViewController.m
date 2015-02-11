//
//  ProfileViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 28/01/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "CollapseClick.h"
#import "WebOperations.h"
#import "UGHDataAccess.h"
#import "NSData+StringEncodings.h"
#import "RadioButton.h"
#import "NSString+Utils.h"
#import "PostImageWebOperation.h"


@interface ProfileViewController ()<UITextFieldDelegate,CollapseClickDelegate,WebOperationDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    BOOL isEdited;
}
@property (nonatomic, strong) UserProfileWebOperation *userProfileInfoWebOp;
@property (nonatomic, strong) UGHDataAccess *dataAccess;
@property (weak, nonatomic) IBOutlet CollapseClick *collapsableScrollView;
@property (strong, nonatomic) IBOutlet UIView *generalInfoView;
@property (strong, nonatomic) IBOutlet UIView *advancedInfoView;
@property (strong, nonatomic) IBOutlet UIView *saveView;
@property (strong, nonatomic) SaveUserProfileWebOperation *saveUserInfoWebOp;
@property (strong, nonatomic) PostImageWebOperation *postImageWebOp;
@property (strong,nonatomic) NSString *genderString;
@property (strong,nonatomic) NSString *profileImageUrl;
@property (weak, nonatomic) IBOutlet RadioButton *maleButton;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *blockNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *flatNoLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailId;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *middleNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *telephoneNoTextField;
@property (weak, nonatomic) IBOutlet UILabel *bloodGroupLabel;
@property (weak, nonatomic) IBOutlet UITextField *dobTextField;
@property (weak, nonatomic) IBOutlet UITextField *alternatEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *altenateContactTextField1;
@property (weak, nonatomic) IBOutlet UITextField *altenateContactTextField2;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *hobbiesTextField;
@property (weak, nonatomic) IBOutlet UITextField *languagesTextField;

@property (weak, nonatomic) IBOutlet UIButton *ownerTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *residentTypeButton;
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic, assign) BOOL isResident;

- (IBAction)scrollViewTaped:(id)sender;
- (IBAction)saveProfilesAction:(id)sender;
- (IBAction)genderButtonTapped:(id)sender;
- (IBAction)residentTypeSlected:(id)sender;
- (IBAction)ChangeUserPhotoTapped:(id)sender;

@end
//*******************************************************************************************//
#pragma mark Constants
#define OwnerTag 100
#define ResidentTag 200
static NSString * const PROFILE_USERID = @"UserId";
static NSString * const PROFILE_EMAIL = @"Email";
static NSString * const PROFILE_ALTEMAIL = @"AltEmail";
static NSString * const PROFILE_MOBILENUMBER = @"MobileNumber";
static NSString * const PROFILE_FIRSTNAME = @"FirstName";
static NSString * const PROFILE_LASTNAME = @"LastName";
static NSString * const PROFILE_MIDDLENAME = @"MiddleName";
static NSString * const PROFILE_GENDER = @"Gender";
static NSString * const PROFILE_USERNAME = @"UserName";
static NSString * const PROFILE_DOB = @"DateOfBirth";
static NSString * const PROFILE_TELEPHONE = @"TelephoneNumber";
static NSString * const PROFILE_ALTCONTACTNUMBER = @"AltContactNumber";
static NSString * const PROFILE_BLOODGROUP = @"BloodGroup";
static NSString * const PROFILE_LANGUAGES = @"LanguagesSpoken";
static NSString * const PROFILE_ALTADDRESS = @"AlternateAddress";
static NSString * const PROFILE_PHOTO = @"Photo";
static NSString * const PROFILE_BOOL_MASKPHONENUMBER = @"MaskPhoneNumber";
static NSString * const PROFILE_BOOL_MASKEMAIL = @"MaskEmail";
static NSString * const PROFILE_HOBBIES = @"Hobbies";
static NSString * const PROFILE_RESGROUPID = @"ResidenceGroupId";
static NSString * const PROFILE_SOCIETYID = @"SocietyId";
static NSString * const PROFILE_FLATID = @"FlatId";
static NSString * const PROFILE_BLOCKID = @"BlockId";
static NSString * const PROFILE_BOOL_ISOWNER = @"IsOwner";
static NSString * const PROFILE_BOOL_ISRESIDENT = @"IsResident";
static NSString * const PROFILE_SOCIETYNAME = @"SocietyName";
static NSString * const PROFILE_BLOCKNAME = @"BlockName";
static NSString * const PROFILE_FLATNUMBER = @"FlatNumber";
static NSString * const PROFILE_LASTLOGINSOCIETY = @"LastLoginSociety";
static NSString * const PROFILE_ACCESSID = @"AccessId";
static NSString * const PROFILE_LOGO = @"Logo";
//*******************************************************************************************//

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    // Do any additional setup after loading the view from its nib.
    [self setupInitialElements];
}

- (void)setupInitialElements {
    [self homebutton];
    isEdited = NO;
    self.collapsableScrollView.CollapseClickDelegate = self;
    [self.collapsableScrollView reloadCollapseClick];
    
    [self.profileImageView.layer setCornerRadius:self.profileImageView.bounds.size.width/2];
    self.profileImageView.clipsToBounds=YES;
    self.dataAccess = [UGHDataAccess sharedDataAccess];
    [self initilizeDatePicker];
    [self getUserProfileInformation];
}

- (void)initilizeDatePicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dobTextField setInputView:datePicker];
}

-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.dobTextField.inputView;
    [picker setMaximumDate:[NSDate date]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    self.dobTextField.text = [NSString stringWithFormat:@"%@",dateString];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)homebutton
{
    SWRevealViewController *revealController = [self revealViewController];
    UIButton *home = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeImage = [UIImage imageNamed:@"menu.png"];
    [home setBackgroundImage:homeImage forState:UIControlStateNormal];
    [home addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    home.frame = CGRectMake(0, 0, 30, 20);
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:home];
    [[self navigationItem] setLeftBarButtonItem:button2];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}
- (void)revealToggle:(id)sender {
    
}
#pragma mark Network Operations
- (void)getUserProfileInformation {
    if (self.userProfileInfoWebOp) {
        return; // web op already in progess
    }
    if (![self.dataAccess isConnected]) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    self.userProfileInfoWebOp = [[UserProfileWebOperation alloc] initWithDelegate:self];
    self.userProfileInfoWebOp.userId = self.dataAccess.userId;
    self.userProfileInfoWebOp.password = ((NSDictionary *)self.dataAccess.loginCredentials)[KPASSWORD];
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.userProfileInfoWebOp];
}

- (void)postImageForBytesArray:(id)bytesArray {
    if (self.postImageWebOp) {
        return;
    }
    self.postImageWebOp = [[PostImageWebOperation alloc] initWithDelegate:self];
    self.postImageWebOp.imageBytesArray = bytesArray;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.postImageWebOp];
}
- (void)saveUpdatedUserProfileInformationWithValues:(NSDictionary *)parameters {
    if (self.saveUserInfoWebOp) {
        return;
    }
    self.saveUserInfoWebOp = [[SaveUserProfileWebOperation alloc] initWithDelegate:self];
    self.saveUserInfoWebOp.paramsDictionary = parameters;
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.saveUserInfoWebOp];
}

#pragma mark webOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    if (webOp == self.userProfileInfoWebOp) {
        self.userProfileInfoWebOp = nil;
        NSDictionary *response = ((UserProfileWebOperation *)webOp).responseDictionary;
        [self updateUiForResposeDictionary:response];
    }else if(webOp == self.saveUserInfoWebOp) {
        self.saveUserInfoWebOp = nil;
        id response = ((SaveUserProfileWebOperation *)webOp).response;
        [self handleProfileSaveResponse:response];
    }else if (webOp == self.postImageWebOp) {
        self.postImageWebOp = nil;
        NSString *path = ((PostImageWebOperation *)webOp).imagePath;
        if (!path) {
            return;
        }
        self.profileImageUrl = [path applicationImageUrlString];
    }else {
        return;
    }
}

- (void)handleProfileSaveResponse:(id)response {
    if ([[response stringValue] isEqualToString:@"1"]) {
        ShowAlert(@"Profile", @"Saved Successfully..!")
//        [self.navigationController popViewControllerAnimated:NO];
        //set editing BOOL to NO
    }
}
- (void)updateUiForResposeDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return;
    }
    self.profileImageUrl = dictionary[PROFILE_PHOTO];
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",API_BASE_IMAGE_URL,dictionary[PROFILE_PHOTO]]] placeholderImage:PLACEHOLDER];
    self.userNameLbl.text = dictionary [PROFILE_USERNAME];
    self.blockNameLabel.text = dictionary [PROFILE_BLOCKNAME];
    self.flatNoLabel.text = dictionary [PROFILE_FLATNUMBER];
    self.emailId.text = dictionary [PROFILE_EMAIL];
    self.phoneNoTextField.text = dictionary [PROFILE_MOBILENUMBER];
    self.firstNameTextField.text = dictionary [PROFILE_FIRSTNAME];
    self.lastNameTextField.text = dictionary [PROFILE_LASTNAME];
    self.middleNameTextField.text = dictionary [PROFILE_MIDDLENAME];
    self.telephoneNoTextField.text = dictionary [PROFILE_TELEPHONE];
    self.bloodGroupLabel.text = @"B+";            //[dictionary [PROFILE_BLOODGROUP] stringValue]; for nOw hardcoded
    self.dobTextField.text = [self dateTostring:dictionary [PROFILE_DOB]];
    self.alternatEmailTextField.text = dictionary[PROFILE_ALTEMAIL];
    self.altenateContactTextField1.text = dictionary [PROFILE_ALTCONTACTNUMBER];
    //    self.altenateContactTextField2.text
    self.addressTextField.text = dictionary [PROFILE_ALTADDRESS];
    self.hobbiesTextField.text = dictionary [PROFILE_HOBBIES];
    self.languagesTextField.text = dictionary [PROFILE_LANGUAGES];
    [dictionary [PROFILE_BOOL_ISOWNER] boolValue] ? [self.ownerTypeButton setSelected:YES] : [self.ownerTypeButton setSelected:NO];
    [dictionary [PROFILE_BOOL_ISRESIDENT] boolValue] ? [self.residentTypeButton setSelected:YES] : [self.residentTypeButton setSelected:NO];
    [dictionary [PROFILE_GENDER] integerValue] == 1 ? [self.maleButton setSelected:YES] : [self.maleButton setSelected:NO];
    self.genderString = dictionary[PROFILE_GENDER];
}

-(NSString *)dateTostring:(NSDate *)createdOn {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *createdOnString =  [NSString stringWithFormat:@"%@",createdOn];
    NSDate *createdOnDate = [formatter dateFromString:createdOnString];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [formatter stringFromDate:createdOnDate];
    return dateString;
}
#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 3;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"General";
            break;
        case 1:
            return @"Advanced";
            break;
        case 2:
            return @"Save";
            break;
        default:
            return @"";
            break;
    }
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
    if (index == 0) {
        NSArray *indexArray = @[[NSNumber numberWithInt:1],[NSNumber numberWithInt:2]];
        [self.collapsableScrollView closeCollapseClickCellsWithIndexes:indexArray animated:NO];
    }else if (index == 1) {
        NSArray *indexArray = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:2]];
        [self.collapsableScrollView closeCollapseClickCellsWithIndexes:indexArray animated:NO];
    }else {
        NSArray *indexArray = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:1]];
        [self.collapsableScrollView closeCollapseClickCellsWithIndexes:indexArray animated:NO];
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return self.generalInfoView;
            break;
        case 1:
            return self.advancedInfoView;
            break;
        case 2:
            return self.saveView;
            break;
            
        default:
            return self.generalInfoView;
            break;
    }
}

#pragma mark TextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    isEdited = YES;
    [self.collapsableScrollView setContentOffset:CGPointMake(0,textField.center.y-140) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.collapsableScrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark Actions

- (IBAction)saveProfilesAction:(id)sender {
#warning how can we insert nil objects in dictionary ios
    if (![self.dataAccess isConnected]) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    //blood Group hard coded
    NSDictionary *params = @{PROFILE_USERID : self.dataAccess.userId,
                             PROFILE_PHOTO:self.profileImageUrl,
                             PROFILE_EMAIL:self.emailId.text,
                             PROFILE_MOBILENUMBER:self.phoneNoTextField.text,
                             PROFILE_FIRSTNAME:self.firstNameTextField.text,
                             PROFILE_LASTNAME:self.lastNameTextField.text,
                             PROFILE_MIDDLENAME:self.middleNameTextField.text,
                             PROFILE_TELEPHONE:self.telephoneNoTextField.text,
                             PROFILE_GENDER : self.genderString,
                             PROFILE_BLOODGROUP:@"2",
                             PROFILE_DOB:self.dobTextField.text,
                             PROFILE_ALTEMAIL:self.alternatEmailTextField.text,
                             PROFILE_ALTCONTACTNUMBER:self.altenateContactTextField1.text,
                             PROFILE_ALTADDRESS:self.addressTextField.text,
                             PROFILE_HOBBIES:self.hobbiesTextField.text,
                             PROFILE_LANGUAGES:self.languagesTextField.text};
    [self saveUpdatedUserProfileInformationWithValues:params];
                             
// PROFILE_USERNAME:self.userNameLbl.text,
// PROFILE_BLOCKNAME:self.blockNameLabel.text,
// PROFILE_FLATNUMBER:self.flatNoLabel.text,
}

- (IBAction)genderButtonTapped:(RadioButton *)sender {
//    self.genderString = sender.titleLabel.text;
    self.genderString = [NSString stringWithFormat:@"%lu",sender.tag];
}

- (IBAction)residentTypeSlected:(id)sender {
    UIButton * button  = (UIButton *)sender;
    if (button.tag == OwnerTag) {
        [self.ownerTypeButton setSelected:YES];
        [self.residentTypeButton setSelected:NO];
        self.isOwner = YES;
        self.isResident = NO;
    }else if (button.tag == ResidentTag) {
        [self.ownerTypeButton setSelected:NO];
        [self.residentTypeButton setSelected:YES];
        self.isOwner = NO;
        self.isResident = YES;
    }
}

- (IBAction)ChangeUserPhotoTapped:(id)sender {
    [self showActionSheet];
}

- (void)showActionSheet {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Camera", @"Photo Library",nil];
    [actionSheet showInView:self.view];
}

- (IBAction)scrollViewTaped:(id)sender {
    [self.view endEditing:YES];
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
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    NSString *imageBytesArray = [imageData base64Encoded];
    [self postImageForBytesArray:imageBytesArray];
    self.profileImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
