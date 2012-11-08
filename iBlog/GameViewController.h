//
//  GameViewController.h
//  iBlog
//
//  Created by Yong Su on 23/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "Car.h"

@interface GameViewController : UIViewController
{
    CADisplayLink *displayLink;
    Car *car;
}

- (void)updateScene;
- (void)viewTapped:(UIGestureRecognizer *)aGestureRecognizer;

@end
