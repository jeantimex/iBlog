//
//  Post.h
//  iBlog
//
//  Created by Yong Su on 19/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject <NSCoding>
{
    
}

@property NSUInteger identifier;
@property NSUInteger forward;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *date;
@property (retain, nonatomic) NSString *time;
@property (retain, nonatomic) NSString *image;

@end
