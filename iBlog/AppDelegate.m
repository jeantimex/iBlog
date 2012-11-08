//
//  AppDelegate.m
//  iBlog
//
//  Created by Yong Su on 9/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "PostsTableViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "ToolViewController.h"
#import "GameViewController.h"
#import "downloadOperation.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize homeNavigationController;
@synthesize toolNavigationController;
@synthesize postsTableViewController;

NSString *kRemindMeNotificationDataKey = @"kRemindMeNotificationDataKey";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Show the status bar once finish launching
    //[[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    
    // Tab 1
    postsTableViewController = [[PostsTableViewController alloc] initWithNibName:@"PostsTableViewController" bundle:nil];
    
    // Create UINavigationController and init with HomeViewController
    homeNavigationController = [[UINavigationController alloc] initWithRootViewController:postsTableViewController];
    homeNavigationController.tabBarItem.title = @"Home";
    homeNavigationController.tabBarItem.image = [UIImage imageNamed:@"home"];
    
    // Tab 2
    UIViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" 
                                                                                      bundle:nil];
    messageViewController.tabBarItem.title = @"Message";
    messageViewController.tabBarItem.image = [UIImage imageNamed:@"message"];
    
    // Tab 3
    UIViewController *profileViewController = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" 
                                                                                      bundle:nil];
    profileViewController.tabBarItem.title = @"Profile";
    profileViewController.tabBarItem.image = [UIImage imageNamed:@"profile"];
    
    // Tab 4
    UIViewController *toolViewController = [[ToolViewController alloc] initWithNibName:@"ToolViewController" 
                                                                                      bundle:nil];
    
    toolNavigationController = [[UINavigationController alloc] initWithRootViewController:toolViewController];
    toolNavigationController.tabBarItem.title = @"Tool";
    toolNavigationController.tabBarItem.image = [UIImage imageNamed:@"tool"];
    
    // Tab 5
    UIViewController *gameViewController = [[GameViewController alloc] initWithNibName:@"GameViewController" 
                                                                                      bundle:nil];
    gameViewController.tabBarItem.title = @"Game";
    gameViewController.tabBarItem.image = [UIImage imageNamed:@"game"];
    
    // Customize the navigation bar appearance
    // 1. background image
    UIImage *navigationPortraitBackground = [[UIImage imageNamed:@"navigationPortraitBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UINavigationBar appearance] setBackgroundImage:navigationPortraitBackground forBarMetrics:UIBarMetricsDefault];
    // 2. text on navigation bar
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:67/255.0 green:91/255.0 blue:119/255.0 alpha:1], UITextAttributeTextColor,
      [UIColor whiteColor], UITextAttributeTextShadowColor, 
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
      nil]];
    
    // Create the tab bar controller
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             homeNavigationController, 
                                             messageViewController, 
                                             profileViewController, 
                                             toolNavigationController,
                                             gameViewController,
                                             nil];
    
    // Customize the tab bar appearance
    UITabBar *tabBar = [self.tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        [tabBar setBackgroundImage:[[UIImage imageNamed:@"tabBarPortraitBackground"] 
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    }
    
    // consume notification
    
    UILocalNotification *notification = [launchOptions objectForKey:
                                         UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification) {
        NSLog(@"notification in didFinishLaunchingWithOptions");
        //NSString *reminderText = [notification.userInfo objectForKey:kRemindMeNotificationDataKey];
        //[postsTableViewController showReminder];
    }
	
	application.applicationIconBadgeNumber = 0;
    
    // schedule new notification
    //[postsTableViewController scheduleNotification];
    
    // Set the window root view controller
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    
    NSLog(@"applicationDidEnterBackground, save posts array");
    [postsTableViewController savePostsArray];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application 
didReceiveLocalNotification:(UILocalNotification *)notification {
	NSLog(@"didReceiveLocalNotification");
	// UIApplicationState state = [application applicationState];
	// if (state == UIApplicationStateInactive) {
    
    // Application was in the background when notification
    // was delivered.
	// }
	
	
	application.applicationIconBadgeNumber = 0;
	//NSString *reminderText = [notification.userInfo objectForKey:kRemindMeNotificationDataKey];
	[postsTableViewController showReminder];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
