//
//  FirstViewController.h
//  iBlog
//
//  Created by Yong Su on 9/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface PostsTableViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    BOOL _newOrOld;
    BOOL _finished;
}

@property (strong, nonatomic) NSMutableArray *postsArray;
@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) UIView *loadingIcon;
@property (strong, nonatomic) UIView *notificationView;
@property (strong, nonatomic) UIButton *badgeView;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSURLConnection *urlConnection;
@property (strong, nonatomic) NSTimer *timer;
@property NSInteger timerCount;

- (void)reloadTableViewDataSource;
- (void)refreshButtonClicked;
- (void)doneLoadingNewPosts;
- (void)doneLoadingOldPosts;
- (void)loadOldPosts;
- (void)loadNewPosts;
- (void)showNotification:(NSString *)animationID numberOfNewPosts:(int)numberOfNewPosts finished:(NSNumber *)finished context:(void *)context;
- (void)hideNotification:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)selectRowAtIndexPath:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)performRequestWithUri:(NSString *)requestUri params:(NSString *)params method:(NSString *)method completionHandler:(void (^)(NSDictionary *, NSError *))completionBlock;
- (void)getDataFromServer:(NSString *)requestUri params:(NSString *)params method:(NSString *)method;
- (NSString *)urlEncodeValue:(NSString *)str;
- (NSString *)dataFilePath: (NSString *)fileName;
- (void)savePostsArray;
- (void)updateBadge;
- (void)clearNotification;
- (void)showReminder;
- (void)scheduleNotification;

@end
