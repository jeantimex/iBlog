//
//  Post.m
//  iBlog
//
//  Created by Yong Su on 19/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Post.h"

@implementation Post

@synthesize identifier;
@synthesize content;
@synthesize date;
@synthesize time;
@synthesize image;
@synthesize forward;

- (id)init
{
    self = [super init];
    if (self) 
    {
        identifier = 0;
        content = @"";
        date = @"";
        time = @"";
        image = @"";
        forward = 0;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nid: %@\ncontent: %@\ndate: %@\ntime: %@\nimage: %@\nforward: %@", identifier, content, date, time, image, forward];
}

#pragma mark -
#pragma mark NSCoding delegate methods

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInteger:identifier forKey:@"identifier"];
    [coder encodeObject:content forKey:@"content"];
    [coder encodeObject:date forKey:@"date"];
    [coder encodeObject:time forKey:@"time"];
    [coder encodeObject:image forKey:@"image"];
    [coder encodeInteger:forward forKey:@"forward"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[Post alloc] init];
    if (self != nil)
    {
        identifier = [coder decodeIntegerForKey:@"identifier"];
        content = [coder decodeObjectForKey:@"content"];
        date = [coder decodeObjectForKey:@"date"];
        time = [coder decodeObjectForKey:@"time"];
        image = [coder decodeObjectForKey:@"image"];
        forward = [coder decodeIntegerForKey:@"forward"];
    }   
    return self;
}

@end
