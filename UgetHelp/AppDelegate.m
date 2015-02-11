//
//  AppDelegate.m
//  UgetHelp
//
//  Created by SEA_MAC_01 on 09/12/14.
//  Copyright (c) 2014 SEA_MAC_01. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "HomeViewController.h"
#import "UGHDataAccess.h"

@interface AppDelegate ()<SWRevealViewControllerDelegate>
@property (nonatomic, strong)SWRevealViewController *revealViewController;
@end

@implementation AppDelegate

//9703217544

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self performLoginIfNeeded];
    [self registerForPushNotifications];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark Notifications
- (void)registerForPushNotifications {
    if (IS_OS_8_OR_LATER) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"Received notification: %@", userInfo);
}
#pragma mark Other
- (void)performLoginIfNeeded {
    UGHDataAccess *dataAccess = [UGHDataAccess sharedDataAccess];
    if (!dataAccess.isLoggedIn) {
        self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
        self.window.rootViewController = self.viewController;
    }else {
        HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        SidebarViewController *sideViewController = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sideViewController];
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
        revealController.delegate = self;
        self.revealViewController = revealController;
        self.window.rootViewController = self.revealViewController;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

//-(void)performLoginIfNeded {
//    UGHDataAccess *dataAccess = [UGHDataAccess sharedDataAccess];
//    if (!dataAccess.isLoggedIn) {
//        self.viewController=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
//        self.window.rootViewController = navController;
//    }else{
//        HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
//        SidebarViewController *sideViewController = [[SidebarViewController alloc] initWithNibName:@"SidebarViewController" bundle:nil];
//
//        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:sideViewController];
//
//        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//        revealController.delegate = self;
//
//        self.revealViewController = revealController;
//        self.window.rootViewController = self.revealViewController;
//    }
//}


//    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
//
//    // Change the font style of the navigation bar
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//    shadow.shadowOffset = CGSizeMake(0, 0);
//    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
//                                                           [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
//                                                           shadow, NSShadowAttributeName,
//                                                           [UIFont fontWithName:@"Helvetica-Light" size:21.0], NSFontAttributeName, nil]];
//
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]) {
//        self.homeView=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
//
//        //slideView Controllers
//
//        SidebarViewController *rearViewController = [[[SidebarViewController alloc] init]initWithNibName:@"SidebarViewController" bundle:nil];
//
//        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController: self.homeView];
//        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
//        rearNavigationController.navigationBarHidden=YES;
//        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//        revealController.delegate = self;
//        self.SWviewController = revealController;
//        self.window.rootViewController = self.SWviewController;
//    }else{
//        self.viewController=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
//
//        //slideView Controllers
//
//        SidebarViewController *rearViewController = [[[SidebarViewController alloc] init]initWithNibName:@"SidebarViewController" bundle:nil];
//
//        UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController: self.viewController];
//        UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
//        rearNavigationController.navigationBarHidden=YES;
//        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
//        revealController.delegate = self;
//        self.SWviewController = revealController;
//        self.window.rootViewController = self.SWviewController;
//    }
// Override point for customization after application launch.
