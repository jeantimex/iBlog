//
//  CommentViewController.m
//  iBlog
//
//  Created by Yong Su on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"

@implementation CommentViewController
@synthesize navigationView;
@synthesize cancelButton;
@synthesize commentTextField;
@synthesize netBar;

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

- (void)viewWillAppear:(BOOL)animated
{
    [commentTextField becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBackground"]];
    self.netBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"netbar"]];
    
}

- (void)viewDidUnload
{
    [self setNavigationView:nil];
    [self setCancelButton:nil];
    [self setCommentTextField:nil];
    [self setNetBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onCancelButtonClicked:(id)sender 
{
    if([[commentTextField text] length] > 0)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Comment has not been sent" 
                                                            delegate:self 
                                                            cancelButtonTitle:@"Cancel" 
                                                            destructiveButtonTitle:nil 
                                                            otherButtonTitles:@"Discard", nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle=[actionSheet buttonTitleAtIndex:buttonIndex];
    
    NSLog(@"buttonTitle: %@", buttonTitle);
    
    if([buttonTitle isEqualToString:@"Discard"] == YES)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    
}

@end
