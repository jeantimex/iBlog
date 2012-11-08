//
//  Car.m
//  iBlog
//
//  Created by Yong Su on 23/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <math.h>
#import "Car.h"

@implementation Car

@synthesize speed;
@synthesize moveToPoint;

-(id)init{
    self = [super initWithImage:[UIImage imageNamed:@"car"]];
    if (self != nil){
        [self setSpeed:5];
    }
    return self;
}

- (void)updateLocation
{
    CGPoint c = [self center];
    
    float dx = (moveToPoint.x - c.x);
    float dy = (moveToPoint.y - c.y);
    float theta = atan(dy/dx);
    
    float dxf = cos(theta) * self.speed;
    float dyf = sin(theta) * self.speed;
    
    if (dx < 0) {
        dxf *= -1;
        dyf *= -1;
    }
    
    c.x += dxf;
    c.y += dyf;
    
    if (abs(moveToPoint.x - c.x) < self.speed && abs(moveToPoint.y - c.y) < self.speed) {
        c.x = moveToPoint.x;
        c.y = moveToPoint.y;
    }
    
    [self setCenter:c];
}

- (void)rotateMe:(float)angleRadians
{
    //float angleRadians = angleDegrees * ((float)M_PI / 180.0f);
    CGAffineTransform t = CGAffineTransformMakeRotation(angleRadians);
    self.transform = t;
}

@end
