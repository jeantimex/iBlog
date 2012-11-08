//
//  Car.h
//  iBlog
//
//  Created by Yong Su on 23/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Car : UIImageView
{
    CALayer *_image;
}

@property float speed;
@property CGPoint moveToPoint;

- (void)updateLocation;
- (void)rotateMe:(float)angleRadians;

@end
