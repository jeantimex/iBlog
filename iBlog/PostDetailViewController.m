//
//  PostDetailViewController.m
//  iBlog
//
//  Created by Yong Su on 11/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostDetailViewController.h"

@implementation PostDetailViewController
@synthesize moreButton;
@synthesize forwardBackgroundImageView;
@synthesize toolbarView;
@synthesize postSelected;
@synthesize refreshButton;
@synthesize commentButton;
@synthesize forwardButton;
@synthesize bookmarkButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)navigateBack
{
    NSLog(@"back button is pressed");
    //back to previous view
    [self.navigationController popViewControllerAnimated: TRUE];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear in detail view");
    self.title = self.postSelected;
    
    UIView *container = [self.navigationController.view viewWithTag:99];
    NSLog(@"container: %@", container);
    [container setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Custom initialization
    UIImage *backImage = [UIImage imageNamed:@"toolbarBackButtonBackgroundPortrait"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bounds = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    backButton.frame = CGRectMake(4.0, 10, backImage.size.width, backImage.size.height);
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navigateBack) forControlEvents:UIControlEventTouchUpInside];
    
    // create the container on navigation bar
    UIView* container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [container addSubview:backButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:container];
    
    self.navigationItem.hidesBackButton = YES;
    
    // create the custom tool bar
    self.toolbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"toolbarBackground"]];
    
    // customize tool bar buttons
    [refreshButton setImage:[UIImage imageNamed:@"refresh-white"] forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [forwardButton setImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
    [bookmarkButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    
    // strechable uiimageview
    UIImage *forwardBackgroundImage = [[UIImage imageNamed:@"forwardBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 0, 5, 0)];
    [forwardBackgroundImageView setImage:forwardBackgroundImage];
    
    
    
    /*
    // Custom the tab bar
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        // set it just for this instance
        [tabBar setBackgroundImage:[UIImage imageNamed:@"toolbarBackground"]];
        
        // set for all
        // [[UITabBar appearance] setBackgroundImage: ...
    }
    */
    /*
    if ([tabBar respondsToSelector:@selector(setSelectionIndicatorImage:)])
    {
        
        [tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"tabTransparentBackground"]];
    }
    */
}

- (void)viewDidUnload
{
    [self setPostSelected:nil];
    [self setToolbarView:nil];
    [self setRefreshButton:nil];
    [self setCommentButton:nil];
    [self setForwardButton:nil];
    [self setBookmarkButton:nil];
    [self setMoreButton:nil];
    [self setForwardBackgroundImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Tab Bar Delegate 
/*
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"didSelectItem: %d", item.tag);
}
*/
- (IBAction)onRefreshButtonClicked:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
}

- (IBAction)onCommentButtonClicked:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    CommentViewController *commentView = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    [self presentModalViewController:commentView animated:YES];
    
}

- (IBAction)onForwardButtonClicked:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
}

- (IBAction)onBookmarkButtonClicked:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
}

- (IBAction)onMoreButtonClicked:(id)sender
{
    NSLog(@"%s", __FUNCTION__);
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Please select" 
                                                        delegate:self 
                                                        cancelButtonTitle:@"Cancel" 
                                                        destructiveButtonTitle:nil 
                                                        otherButtonTitles:@"Share by message", @"Share by email", @"Copy", @"Report", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    NSLog(@"buttonTitle: %@", buttonTitle);
    
}

@end
