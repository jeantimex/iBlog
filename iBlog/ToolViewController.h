//
//  ToolViewController.h
//  iBlog
//
//  Created by Yong Su on 11/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    NSMutableArray *allItems;
    NSMutableArray *searchResults;
    NSMutableArray *viewControllers;
    BOOL pageControlUsed;
}

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, copy) NSMutableArray *allItems;
@property (nonatomic, copy) NSMutableArray *searchResults;
@property (strong, nonatomic) IBOutlet UIView *toolsView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property BOOL pageControlUsed;

- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;

@end
