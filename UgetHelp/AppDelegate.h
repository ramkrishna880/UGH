//
//  AppDelegate.h
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/12/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class SWRevealViewController;
@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

- (void)performLoginIfNeeded;
@end

