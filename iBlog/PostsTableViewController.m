//
//  FirstViewController.m
//  iBlog
//
//  Created by Yong Su on 9/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostsTableViewController.h"
#import "PostDetailViewController.h"
#import "PostCell.h"
#import "TipCell.h"
#import "SBJson.h"
#import "Reachability.h"
#import "Post.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

#define SPINNER_SIZE 25

@implementation PostsTableViewController

@synthesize postsArray; 
@synthesize refreshButton;
@synthesize loadingIcon;
@synthesize notificationView;
@synthesize badgeView;
@synthesize receivedData;
@synthesize urlConnection;
@synthesize timer;
@synthesize timerCount;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)newPost
{
    NSLog(@"New Post");
}

- (void)setLocation
{
    NSLog(@"Set Location");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // 1. new post button
    UIImage *newPostImage = [UIImage imageNamed:@"post"];
    UIButton *newPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newPostButton.bounds = CGRectMake(0.0, 0.0, newPostImage.size.width, newPostImage.size.height);
    newPostButton.frame = CGRectMake(4, 10, newPostImage.size.width, newPostImage.size.height);
    [newPostButton setImage:newPostImage forState:UIControlStateNormal];
    newPostButton.showsTouchWhenHighlighted = YES;
    [newPostButton addTarget:self action:@selector(newPost) forControlEvents:UIControlEventTouchUpInside];
    
    // 2. location button
    UIImage *locationImage = [UIImage imageNamed:@"plane"];
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.bounds = CGRectMake(0.0, 0.0, locationImage.size.width, locationImage.size.height);
    locationButton.frame = CGRectMake(40.0, 10, locationImage.size.width, locationImage.size.height);
    locationButton.showsTouchWhenHighlighted = YES;
    [locationButton setImage:locationImage forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(setLocation) forControlEvents:UIControlEventTouchUpInside];
    
    // 3. refresh button
    UIImage *refreshImage = [UIImage imageNamed:@"refresh"];
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.bounds = CGRectMake( 0, 0, refreshImage.size.width, refreshImage.size.height);
    refreshButton.frame = CGRectMake(280, 10, refreshImage.size.width, refreshImage.size.height);
    [refreshButton setImage:refreshImage forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 4. loading indicator
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingIndicator startAnimating];
    loadingIcon = [[UIView alloc] initWithFrame:CGRectMake(282, 13, refreshImage.size.width, refreshImage.size.height)];
    [loadingIcon addSubview:loadingIndicator];
    [loadingIcon setHidden:YES];
    
    // create the container
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 20.0f, 320.0f, 44.0f)];
    container.tag = 99;
    
    UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 44.0f)];
    buttonContainer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBackground"]];
    
    notificationView = [[UIView alloc] initWithFrame:CGRectMake(2.5, 5, 315.0f, 30.0f)];
    //notificationView.bounds = CGRectMake(0, 0, 315, 30);
    notificationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notificationBackground"]];
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, 30, 30)];
    numLabel.text = @"";
    numLabel.tag = 1;
    numLabel.opaque = NO;
    [numLabel setTextAlignment:UITextAlignmentRight];
    [numLabel setBackgroundColor:[UIColor clearColor]];
    [numLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [numLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:211.0/255.0 blue:104.0/255.0 alpha:1]];
    
    UILabel *staticLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 100, 30)];
    staticLabel.text = @"";
    staticLabel.opaque = NO;
    staticLabel.tag = 2;
    staticLabel.textAlignment = UITextAlignmentLeft;
    staticLabel.font = [UIFont boldSystemFontOfSize:16];
    staticLabel.backgroundColor = [UIColor clearColor];
    staticLabel.textColor = [UIColor whiteColor];
    
    
    [notificationView addSubview:numLabel];
    [notificationView addSubview:staticLabel];
    
    [buttonContainer addSubview:newPostButton];
    [buttonContainer addSubview:locationButton];
    [buttonContainer addSubview:refreshButton];
    [buttonContainer addSubview:loadingIcon];
    [buttonContainer setUserInteractionEnabled:TRUE];
    
    [container addSubview:notificationView];
    [container addSubview:buttonContainer];
    
    [self.navigationController.view addSubview:container];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:container];
        
    /*
    // create the container
    UIView* rightContainer = [[UIView alloc] initWithFrame:CGRectMake(292, 0, 28, 44)];
    [rightContainer addSubview:refreshButton];
    [rightContainer addSubview:loadingIcon];
    [rightContainer setUserInteractionEnabled:TRUE];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightContainer];
    */
    
    self.navigationItem.hidesBackButton = YES;
    
    //self.navigationItem.title = @"Posts";
    
    // initialize the postsArray
    self.postsArray = [[NSMutableArray alloc] init];
    // load data from file
    NSString *filePath = [self dataFilePath:@"postsArray.dat"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"postsArray.dat existed");
        
        self.postsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    
    /*for (int i=1; i<=10; i++) {
        Post *post = [[Post alloc] init];
        post.identifier = i;
        post.content = [NSString stringWithFormat:@"post %d", i];
        [self.postsArray addObject:post];
    }*/
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
    
    // hide the navigation bar
    //self.navigationController.navigationBar.hidden = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // tab bar badge
    //UITabBarItem *homeTab = (UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:0];
    //homeTab.badgeValue = nil;
    badgeView = [[UIButton alloc] init];
    [badgeView setUserInteractionEnabled:NO];
    [badgeView setBackgroundImage:[[UIImage imageNamed:@"badgeBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [badgeView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [badgeView.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [badgeView setFrame:CGRectMake(42, 2, 20, 18)];
    
    NSString *lbl = @"";
    CGSize lblSize = [lbl sizeWithFont:[UIFont boldSystemFontOfSize:12]];
    
    [badgeView setTitle:lbl forState:UIControlStateNormal];
    
    // calculate the correct size
    CGFloat lblWidth = lblSize.width + 3*2;
    lblWidth = (lblWidth < 20) ? 20 : lblWidth;
    CGFloat lblHeight = 18;
    CGFloat lblX = 320 / 5 - lblWidth + lblWidth / 2 - 2;
    CGFloat lblY = lblHeight / 2 + 2;
    
    CGRect frame = badgeView.frame;
    frame.size = CGSizeMake(lblWidth, lblHeight);
    badgeView.frame = frame;
    badgeView.center = CGPointMake(lblX, lblY);
    
    [badgeView setHidden:YES];
    
    [self.tabBarController.tabBar addSubview:badgeView];
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    // start a timer
    timerCount = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateBadge) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _refreshHeaderView = nil;
    refreshButton = nil;
    loadingIcon = nil;
    notificationView = nil;
    badgeView = nil;
    receivedData = nil;
    urlConnection = nil;
    timer = nil;
    self.postsArray = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
	_refreshHeaderView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIView *container = [self.navigationController.view viewWithTag:99];
    if(container.hidden)
    {
        [container setHidden:NO];
        refreshButton.alpha = 0.0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        refreshButton.alpha = 1.0;
        [UIView commitAnimations];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.postsArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PostCell";
    static NSString *LastCellIdentifier = @"LastCell";
    static NSString *TipCellIdentifier = @"TipCell";
    
	// Configure the cell.
    NSUInteger row = [indexPath row];
    
    if ([self.postsArray count] > 0) 
    {
        if (row < [self.postsArray count])
        {
            static BOOL nibsRegistered = NO;
            if (!nibsRegistered) {
                UINib *nib = [UINib nibWithNibName:@"PostCell" bundle:nil];
                [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
                nibsRegistered = YES;
            }
            
            PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            Post *post = (Post *)[postsArray objectAtIndex:row];
            cell.name = post.content;
            [cell.avatarImageView setImageWithURL:[NSURL URLWithString:@"http://www.cadre.com.au/tmp/iblog/avatars/1/su.png"]
                           placeholderImage:nil];
            
            UIImage *forwardBackgroundImage = [[UIImage imageNamed:@"forwardBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 5, 0)];
            [cell.forwardBackgroundImageView setImage:forwardBackgroundImage];
            
            // remove the spinner
            UIView *spinner = (UIView *)[cell viewWithTag:1];
            if (spinner.superview) [spinner removeFromSuperview];
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"More...";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            
            // remove the spinner
            UIView *spinner = (UIView *)[cell viewWithTag:1];
            if (spinner.superview && _finished) [spinner removeFromSuperview];
            
            return cell;
        }
    }
    else
    {
        static BOOL tipCellRegistered = NO;
        if (!tipCellRegistered) {
            UINib *nib = [UINib nibWithNibName:@"TipCell" bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:TipCellIdentifier];
            tipCellRegistered = YES;
        }
        
        TipCell *cell = (TipCell *)[tableView dequeueReusableCellWithIdentifier:TipCellIdentifier];
        if (cell == nil) {
            cell = [[TipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TipCellIdentifier];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if ([self.postsArray count] > 0) 
    {        
        if (row < [self.postsArray count])
        {
            // calculate the content height from data
            return 300.0f;
        }
        else
        {
            return 44.0f;
        }
    }
    else
    {
        return 175.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectRowAtIndexPath:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)selectRowAtIndexPath:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if ([self.postsArray count] > 0) 
    {
        if (row < [self.postsArray count])
        {
            PostDetailViewController *postDetailViewController = [[PostDetailViewController alloc] initWithNibName:@"PostDetailViewController" bundle:nil];
            // set detail view
            // ...
            
            // hide bottom tab bar
            self.hidesBottomBarWhenPushed = YES;
            
            // push detail view to navigation stack
            Post *post = (Post *)[postsArray objectAtIndex:row];
            postDetailViewController.postSelected = post.content;
            [self.navigationController pushViewController:postDetailViewController animated:YES];
            
            // show tab bar when navigates back!
            self.hidesBottomBarWhenPushed = NO;
        }
        else
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            // Get center of cell (vertically) 
            int center = [cell frame].size.height / 2;
            
            // Size (width) of the text in the cell
            //CGSize size = [[[cell textLabel] text] sizeWithFont:[[cell textLabel] font]];
            
            // Locate spinner in the center of the cell at end of text
            [spinner setFrame:CGRectMake(200.0, center - SPINNER_SIZE / 2, SPINNER_SIZE, SPINNER_SIZE)];
            spinner.tag = 1;
            [[cell contentView] addSubview:spinner]; 
            
            [spinner startAnimating];
            
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
            
            //[self loadOldPosts];
            [self performSelectorInBackground:@selector(loadOldPosts) withObject:nil];
        }
    }
    else
    {
        //TipCell *cell = (TipCell *)[tableView cellForRowAtIndexPath:indexPath];
        //[cell.tipImage setHidden:YES];
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
	_reloading = YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if ([self.postsArray count] == 0) {
        // First figure out how many sections there are
        NSInteger firstSectionIndex = 0;
        
        // Then grab the number of rows in the last section
        NSInteger firstRowIndex = 0;
        
        // Now just construct the index path
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstRowIndex inSection:firstSectionIndex];
        
        TipCell *cell = (TipCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.tipImage setHidden:YES];
        [cell.tipLabel setHidden:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.postsArray count] == 0 && self.tableView.contentOffset.y == 0) {
        // First figure out how many sections there are
        NSInteger firstSectionIndex = 0;
        
        // Then grab the number of rows in the last section
        NSInteger firstRowIndex = 0;
        
        // Now just construct the index path
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:firstRowIndex inSection:firstSectionIndex];
        
        TipCell *cell = (TipCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.tipImage setHidden:NO];
        [cell.tipLabel setHidden:YES];
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    [self loadNewPosts];
}

- (void)egoRefreshTableTailDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    // First figure out how many sections there are
    NSInteger lastSectionIndex = [self.tableView numberOfSections] - 1;
    
    // Then grab the number of rows in the last section
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
    
    // Now just construct the index path
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    
    [self selectRowAtIndexPath:self.tableView didSelectRowAtIndexPath:indexPath];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)refreshButtonClicked
{
    NSLog(@"%s", __FUNCTION__);
    
    
    [[self tableView] setContentOffset:CGPointMake(0, -60) animated:NO];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:[self tableView]];
}

- (void)loadNewPosts
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];   
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];    
    if (networkStatus == NotReachable) {        
        NSLog(@"There IS NO internet connection");
    }
    
    [refreshButton setHidden:YES];
    [loadingIcon setHidden:NO];
    
    // loading new posts...
    NSString *uri = @"/process.php";
    NSString *params = [NSString stringWithFormat:@"action=%@", [self urlEncodeValue:@"getPosts"]];
    NSString *method = @"POST";
    
    [self performRequestWithUri:uri params:params method:method completionHandler:^(NSDictionary *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"%@", response);
            
            BOOL success = [[response objectForKey:@"success"] boolValue];
            NSLog(@"success: %@", success?@"YES":@"NO");
            if (success) 
            {
                /*SDImageCache *imageCache = [SDImageCache sharedImageCache];
                [imageCache clearMemory];
                [imageCache clearDisk];
                [imageCache cleanDisk];*/
                
                int nNewPosts = 0;
                for (NSDictionary *postDict in [response objectForKey:@"data"])
                {
                    // add new posts
                    Post *post = [[Post alloc] init];
                    
                    post.identifier = (NSUInteger)[postDict objectForKey:@"id"];
                    post.forward = (NSUInteger)[postDict objectForKey:@"forward"];
                    post.content = @"Timex";
                    post.date = (NSString *)[postDict objectForKey:@"date"];
                    post.time = (NSString *)[postDict objectForKey:@"time"];
                    post.image = (NSString *)[postDict objectForKey:@"image"];
                    
                    NSLog(@"%@", post);
                    
                    [self.postsArray insertObject:post atIndex:0];
                    
                    nNewPosts++;
                }
                
                if (nNewPosts > 0) 
                {
                    // hide the badge
                    [badgeView setHidden:YES];
                    
                    // show notification...
                    [self showNotification:nil numberOfNewPosts:nNewPosts finished:nil context:nil];
                }
            }
        }
        
        [self performSelector:@selector(doneLoadingNewPosts) withObject:nil afterDelay:0.0];
    }];
}

- (void)doneLoadingNewPosts
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
    [self.tableView reloadData];
    
    [refreshButton setHidden:NO];
    [loadingIcon setHidden:YES];
}


- (void)loadOldPosts
{
    NSLog(@"load old posts");
    [refreshButton setHidden:YES];
    [loadingIcon setHidden:NO];
    
    // loading old posts...
    NSString *uri = @"/process.php";
    NSString *params = [NSString stringWithFormat:@"action=%@", [self urlEncodeValue:@"getPosts"]];
    NSString *method = @"POST";
    
    [self getDataFromServer:uri params:params method:method];
}

- (void)doneLoadingOldPosts
{
    NSLog(@"done loading old posts");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    [self.tableView reloadData];
    
    [refreshButton setHidden:NO];
    [loadingIcon setHidden:YES];
}

- (void)showNotification:(NSString *)animationID numberOfNewPosts:(int)numberOfNewPosts finished:(NSNumber *)finished context:(void *)context
{
    notificationView.center = CGPointMake(160, 20.0f);
    UILabel *numLabel = (UILabel *)[notificationView viewWithTag:1];
    numLabel.text = [NSString stringWithFormat:@"%d", numberOfNewPosts];
    UILabel *staticLabel = (UILabel *)[notificationView viewWithTag:2];
    staticLabel.text = (numberOfNewPosts > 1) ? @"new posts" : @"new post";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideNotification:finished:context:)];
    notificationView.center = CGPointMake(160, 61.5f);
    [UIView commitAnimations];
}

- (void)hideNotification:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:2.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(doneHideNotification)];
    notificationView.center = CGPointMake(160, 20.0f);
    [UIView commitAnimations];
}

- (void)doneHideNotification
{
    
}

/**********************************************
 *
 *  Retrieve server data asynchronously
 *  Method 1: sendAsynchronousRequest
 *
 **********************************************/

- (void)performRequestWithUri:(NSString *)requestUri params:(NSString *)params method:(NSString *)method completionHandler:(void (^)(NSDictionary *, NSError *))completionBlock
{
    
    // Generate the URL
    NSString *requestUrl;
    NSMutableURLRequest *request;
    
    if ([method caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        // post method
        NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        requestUrl = [NSString stringWithFormat:@"http://www.cadre.com.au/tmp/iblog%@", requestUri];
        
        // Create the connection
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }
    else
    {
        // get method
        if (params != nil) {
            requestUri = [NSString stringWithFormat:@"%@?%@", requestUri, params];
        }
        requestUrl = [NSString stringWithFormat:@"http://www.cadre.com.au/tmp/iblog%@", requestUri];
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
        [request setHTTPMethod:@"GET"];
    }
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:60.0f];
    
    // Make an NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:requestUri];
    
    // Send an asyncronous request on the queue
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // If there was an error getting the data
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                completionBlock(nil, error);
            });
            return;
        }
        
        // Decode the data
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        // If there was an error decoding the JSON
        if (jsonError) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {});
            return;
        }
        
        // All looks fine, lets call the completion block with the response data
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            completionBlock(responseDict, nil);
        });
    }];
}

/**********************************************
 *
 *  Retrieve server data asynchronously
 *  Method 2: NSURLConnection + NSRunLoop
 *
 **********************************************/

- (void)getDataFromServer:(NSString *)requestUri params:(NSString *)params method:(NSString *)method
{
    NSLog(@"getDataFromServer...");
    // Generate the URL
    NSString *requestUrl;
    NSMutableURLRequest *request;
    
    if ([method caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        // post method
        NSData *postData = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        requestUrl = [NSString stringWithFormat:@"http://www.cadre.com.au/tmp/iblog%@", requestUri];
        
        // Create the connection
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }
    else
    {
        // get method
        if (params != nil) {
            requestUri = [NSString stringWithFormat:@"%@?%@", requestUri, params];
        }
        requestUrl = [NSString stringWithFormat:@"http://www.cadre.com.au/tmp/iblog%@", requestUri];
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
        [request setHTTPMethod:@"GET"];
    }
    
    // cancel any old connection
    if (urlConnection) {
        [urlConnection cancel];
    }
    
    // create new connection and begin loading data
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if(urlConnection)
    {
        receivedData = nil;
        receivedData = [NSMutableData data];
    }
    
    _finished = NO;
    while(!_finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

// Event handler
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Receive response");
    [receivedData setLength: 0];           
}

-(void)connection: (NSURLConnection*)connection didReceiveData:(NSData*)data
{
    NSLog(@"Recieved data");
    [receivedData appendData:data];
}

-(void)connection: (NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error with conenction");
    _finished = YES;
    
    urlConnection = nil;
    receivedData = nil;
    
    [self performSelector:@selector(doneLoadingOldPosts) withObject:nil afterDelay:0.0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _finished = YES;
    
    // Connection succeeded in downloading the request.
    NSString *dataString = [[NSString alloc] 
                            initWithData:receivedData
                            encoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonData = [dataString JSONValue];
    
    NSLog(@"Succeeded! Received %@: ", jsonData);
    
    // add old posts
    Post *post = [[Post alloc] init];
    post.content = @"old post";
    [self.postsArray addObject:post];
    
    urlConnection = nil;
    receivedData = nil;
    
    [self performSelector:@selector(doneLoadingOldPosts) withObject:nil afterDelay:0.0];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

// url encode
- (NSString *)urlEncodeValue:(NSString *)str
{
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// Data persistant
- (NSString *)dataFilePath: (NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)savePostsArray
{
    if (![NSKeyedArchiver archiveRootObject:self.postsArray toFile:[self dataFilePath:@"postsArray.dat"]])
    {
        NSLog(@"Save postsArray failed.");
    }
}

// timer
- (void)updateBadge
{
    //NSLog(@"update badge.");
    timerCount++;
    
    NSString *lbl = [NSString stringWithFormat:@"%d", timerCount];
    CGSize lblSize = [lbl sizeWithFont:[UIFont boldSystemFontOfSize:12]];
    
    [badgeView setTitle:lbl forState:UIControlStateNormal];
    
    // calculate the correct size
    CGFloat lblWidth = lblSize.width + 3*2;
    lblWidth = (lblWidth < 20) ? 20 : lblWidth;
    CGFloat lblHeight = 18;
    CGFloat lblX = 320 / 5 - lblWidth + lblWidth / 2 - 2;
    CGFloat lblY = lblHeight / 2 + 2;
    
    CGRect frame = badgeView.frame;
    frame.size = CGSizeMake(lblWidth, lblHeight);
    badgeView.frame = frame;
    badgeView.center = CGPointMake(lblX, lblY);
    
    [badgeView setHidden:NO];
    
    if (timerCount >= 999) {
        [timer invalidate];
        timer = nil;
    }
}

// notification
#pragma mark -
#pragma mark === View Actions ===
#pragma mark -

- (void)clearNotification {
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)scheduleNotification 
{	
    NSLog(@"scheduleNotification");
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    notif.fireDate = [dateFormat dateFromString:@"02/19/2012 23:50:00"];
    notif.timeZone = [NSTimeZone defaultTimeZone];
    NSLog(@"%@", notif.fireDate);
    
    notif.alertBody = @"Did you forget something?";
    notif.alertAction = @"Show me";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"Jean.Timex" forKey:kRemindMeNotificationDataKey];
    notif.userInfo = userDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}


#pragma mark -
#pragma mark === Public Methods ===
#pragma mark -

- (void)showReminder {
	NSLog(@"show reminder");
}

@end
