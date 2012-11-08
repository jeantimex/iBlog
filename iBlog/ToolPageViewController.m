//
//  ToolPageViewController.m
//  iBlog
//
//  Created by Yong Su on 22/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToolPageViewController.h"

@implementation ToolPageViewController

+ (UIColor *)pageControlColorWithIndex:(NSUInteger)index {
        NSArray *__pageControlColorList = [[NSArray alloc] initWithObjects:[UIColor grayColor], [UIColor greenColor], [UIColor magentaColor],
                                  [UIColor blueColor], [UIColor orangeColor], [UIColor brownColor], [UIColor redColor], nil];
    return [__pageControlColorList objectAtIndex:index % [__pageControlColorList count]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPageNumber:(int)page {
    if (self = [super initWithNibName:@"ToolPageViewController" bundle:nil])    {
        pageNumber = page;
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
    self.view.backgroundColor = [ToolPageViewController pageControlColorWithIndex:pageNumber];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
