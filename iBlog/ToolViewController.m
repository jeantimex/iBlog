//
//  ToolViewController.m
//  iBlog
//
//  Created by Yong Su on 11/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToolViewController.h"
#import "ToolPageViewController.h"

#define kNumberOfPages 5

@implementation ToolViewController

@synthesize searchDisplayController;
@synthesize tableView;
@synthesize searchBar;
@synthesize allItems;
@synthesize searchResults;
@synthesize toolsView;
@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;
@synthesize pageControlUsed;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set title
    self.navigationItem.title = @"Tools";
    [self.searchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"One",@"Two",@"Three",nil]];
    
    [self.tableView setScrollEnabled:NO];
    
    // initialize scrollview
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    
    self.pageControl.numberOfPages = kNumberOfPages;
    self.pageControl.currentPage = 0;
    
    pageControlUsed = NO;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [self setTableView:nil];
    [self setSearchDisplayController:nil];
    [self setToolsView:nil];
    allItems = nil;
    searchResults = nil;
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setViewControllers:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setShowsScopeBar:YES];
    //[self.searchBar sizeToFit];
    
    [self.tableView setScrollEnabled:YES];
    
    // hide tools view
    [self.toolsView setHidden:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    // search
    if (self.searchBar.text == nil || [self.searchBar.text isEqualToString:@""]) 
    {
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchBar setShowsScopeBar:NO];
        //[self.searchBar sizeToFit];
        
        [self.tableView setScrollEnabled:NO];
        
        // show tools view
        [self.toolsView setHidden:NO];
    }
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar setShowsScopeBar:NO];
    //[self.searchBar sizeToFit];
    
    [self.tableView setScrollEnabled:NO];
    
    // show tools view
    [self.toolsView setHidden:NO];
}

- (void)loadScrollViewWithPage:(int)page 
{
    if (page < 0) return;
    if (page >= kNumberOfPages) return;
    
    ToolPageViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[ToolPageViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender 
{
    if (self.pageControlUsed) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    self.pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender 
{
    int page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    self.pageControlUsed = YES;
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ResultCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
