//
//  GameViewController.m
//  iBlog
//
//  Created by Yong Su on 23/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

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
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    car = [Car new];
    
    CGRect frame = [self.view frame];
    
    car.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
    [self.view addSubview:car];
    [car setMoveToPoint:car.center];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScene)];
    
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
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

- (void)updateScene
{
    [car updateLocation];
}

- (void)viewTapped:(UIGestureRecognizer *)aGestureRecognizer
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)aGestureRecognizer;
    CGPoint tapPoint = [tapRecognizer locationInView:self.view];
    [car setMoveToPoint:tapPoint];
}

@end
