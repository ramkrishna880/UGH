//
//  HomeViewController.m
//  UgetHelp
//
//  Created by A3it on 12/9/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "SWRevealViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Home";
    self.navigationController.navigationBarHidden=NO;
    
    [self homebutton];

    // Do any additional setup after loading the view.
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
