//
//  MaintenanceRecieptsViewController.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 06/02/15.
//  Copyright (c) 2015 SEA_MAC_01. All rights reserved.
//

#import "MaintenanceRecieptsViewController.h"
#import "WebOperations.h"
#import "NSDictionary+Utils.h"
#import "GetMaintenanceRecieptsWebOperation.h"
#import "SWRevealViewController.h"
#import "UGHDataAccess.h"

@interface MaintenanceRecieptsViewController ()<WebOperationDelegate, UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *keys;
}
@property (nonatomic, strong) GetMaintenanceRecieptsWebOperation *maintenanceWebOp;
@property (nonatomic, strong) NSMutableArray *maintenanceReciepts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@end

@implementation MaintenanceRecieptsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupInitialElements];
}

- (void)setupInitialElements {
    self.title = @"Maintenance Reciepts";
    [self homebutton];
    [self fetchMaintenanceRecieptsFromWeb];
    self.headerLabel.text = @"Closing Balance : ";
    [self.navigationController.navigationBar setTranslucent:NO];
    keys = [NSMutableArray arrayWithObjects:@"Date",@"Type",@"Reference #",@"Narration",@"Due Date",@"Debit",@"Balance", nil];
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
    [home addTarget:revealController action:@selector(revealToggle:)
   forControlEvents:UIControlEventTouchUpInside];
    home.frame = CGRectMake(0, 0, 30, 20);
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:home];
    [[self navigationItem] setLeftBarButtonItem:button2];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
}

- (void)fetchMaintenanceRecieptsFromWeb {
    UGHDataAccess *access = [UGHDataAccess sharedDataAccess];
    if (!access.isConnected) {
        ShowAlert(@"", @"No Internet Connection")
        return;
    }
    if (self.maintenanceWebOp) {
        return; // web op already in progess
    }
    self.maintenanceWebOp = [[GetMaintenanceRecieptsWebOperation alloc] initWithDelegate:self];
    [[WebOperationQueue sharedWebOperationQueue] addOperation:self.maintenanceWebOp];
}

#pragma mark - WebOperationDelegate
- (void)webOperationCompleted:(WebOperation *)webOp {
    self.maintenanceWebOp = nil;
    NSMutableArray *responseArray = ((GetMaintenanceRecieptsWebOperation *)webOp).maintenanceRecieptsResponse;
    if (!responseArray) {
        ShowAlert(@"", @"No response")
        return;
    }
    self.headerLabel.text = [NSString stringWithFormat:@"Closing Balance: %@",[responseArray[0] valueForKey:@"ClosingBalance"]];
    self.maintenanceReciepts = [self convertResponseIntoArrayOfDictionaries:responseArray];
    [self.tableView reloadData];
}

- (NSMutableArray *)convertResponseIntoArrayOfDictionaries:(NSMutableArray *)array {
    NSMutableArray *tempArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dictionary = [obj dictionaryByRecursivelyRemovingNSNulls];
        NSString *transactionDate = [self dateTostring:dictionary[@"TransactionDate"]];
        NSString *dueDate = [self dateTostring:dictionary[@"DueDate"]];
        NSString *balance = dictionary[@"ClosingBalance"];
        //        NSString *transactionDate = [self dateTostring:obj[@"TransactionDate"]];
        //        NSString *dueDate = [self dateTostring:obj[@"DueDate"]];
        //        NSString *balance = obj[@"ClosingBalance"];
        NSString *type, *referenceText, *debitText,*debitKey, *narrationText;
        
        if ([dictionary[@"Debit"] integerValue]>0) {
            type = dictionary[@"InvoiceHead"];
            referenceText = obj[@"InvoiceNo"];
            debitText = dictionary[@"Debit"];
            debitKey = @"Debit";
        }else {
            type = @"Paid";
            referenceText = dictionary [@"PaymentReferenceNo"];
            debitText = dictionary[@"Credit"];
            debitKey = @"Credit";
        }
        NSString *description = dictionary [@"Description"];
        if ([dictionary [@"UtilityBillType"] isEqualToString:@""]) {
            narrationText = [NSString stringWithFormat:@"Pr:%@ Cr:%@ Ur:%@ Pr:%@ %@",dictionary [@"PreviousReading"],dictionary [@"CurrentReading"],dictionary [@"UnitRate"],dictionary [@"TotalUnits"],description];
        }else {
            narrationText = description;
        }
        //        if ([obj[@"Debit"] integerValue]>0) {
        //            type = obj[@"InvoiceHead"];
        //            referenceText = obj[@"InvoiceNo"];
        //            debitText = obj[@"Debit"];
        //            debitKey = @"Debit";
        //        }else {
        //            type = @"Paid";
        //            referenceText = [obj[@"PaymentReferenceNo"] isEqual:[NSNull null]] ? @"" : obj[@"PaymentReferenceNo"];
        //            debitText = [obj[@"Credit"] isEqual:[NSNull null]] ? @"" : obj[@"Credit"];
        //            debitKey = @"Credit";
        //        }
        //
        //        NSString *description = [obj[@"Description"] isEqual:[NSNull null]] ? @"" : obj[@"Description"];
        //        if ([obj[@"UtilityBillType"] isEqual:[NSNull null]]) {
        //            NSString *prevReading = [obj[@"PreviousReading"] isEqual:[NSNull null]] ? @"" : obj[@"PreviousReading"];
        //            NSString *currentReading = [obj[@"CurrentReading"] isEqual:[NSNull null]] ? @"" : obj[@"CurrentReading"];
        //            NSString *unitRate = [obj[@"UnitRate"] isEqual:[NSNull null]] ? @"" : obj[@"UnitRate"];
        //            NSString *totalUnits = [obj[@"TotalUnits"] isEqual:[NSNull null]] ? @"" : obj[@"TotalUnits"];
        //            narrationText = [NSString stringWithFormat:@"Pr:%@ Cr:%@ Ur:%@ Pr:%@ %@",prevReading,currentReading,unitRate,totalUnits,description];
        //        }else {
        //            narrationText = description;
        //        }
        [keys replaceObjectAtIndex:5 withObject:debitKey];
        NSDictionary *dict =  @{@"Date":transactionDate,@"Type":type,@"Reference #":referenceText,@"Narration":narrationText,@"Due Date":dueDate,debitKey:debitText,@"Balance":balance};
        [tempArray addObject:dict];
        
    }];
    return tempArray;
}

#pragma mark TableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.maintenanceReciepts.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return keys.count-1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    UILabel *keyLabel, *valueLabel;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
        keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 11, 100, 22)];
        [keyLabel setTextAlignment:NSTextAlignmentLeft];
        [keyLabel setTextColor:[UIColor blackColor]];
        keyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell addSubview:keyLabel];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(keyLabel.frame.origin.x+keyLabel.frame.size.width+10, 11, 190, 22)];
        [valueLabel setTextAlignment:NSTextAlignmentLeft];
        [valueLabel setTextColor:[UIColor blackColor]];
        keyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell addSubview:valueLabel];
    }
    //    NSDictionary *dictionary = self.maintenanceReciepts [indexPath.section];
    //    keyLabel.text = [dictionary allKeys][indexPath.row];
    //    valueLabel.text = [dictionary valueForKey:[dictionary allKeys][indexPath.row]];
    NSString *key = keys[indexPath.row+1];
    keyLabel.text = key;
    valueLabel.text = self.maintenanceReciepts[indexPath.section][key];
    return cell;
}

- (NSString *)dateTostring:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateStr =  [NSString stringWithFormat:@"%@",date];
    NSDate *parsedDate = [formatter dateFromString:dateStr];
    [formatter setDateFormat:@"dd'th' MMM YYYY hh:mm a"];
    NSString *dateString = [formatter stringFromDate:parsedDate];
    return dateString;
}

#pragma mark TableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:102/255 green:1 blue:1 alpha:0.5];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, 100, 25)];
    [keyLabel setTextAlignment:NSTextAlignmentLeft];
    [keyLabel setTextColor:[UIColor blackColor]];
    keyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [view addSubview:keyLabel];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(keyLabel.frame.origin.x+keyLabel.frame.size.width+10, 3, 190, 25)];
    [valueLabel setTextAlignment:NSTextAlignmentLeft];
    [valueLabel setTextColor:[UIColor blackColor]];
    keyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [view addSubview:valueLabel];
    
    keyLabel.text = @"Date";
    valueLabel.text = [self.maintenanceReciepts[section] valueForKey:@"Date"];
    return view;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return @"Name";
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
