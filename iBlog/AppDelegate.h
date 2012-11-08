//
//  AppDelegate.h
//  iBlog
//
//  Created by Yong Su on 9/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostsTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *homeNavigationController;
@property (strong, nonatomic) UINavigationController *toolNavigationController;
@property (strong, nonatomic) PostsTableViewController *postsTableViewController;

extern NSString *kRemindMeNotificationDataKey;

@end
