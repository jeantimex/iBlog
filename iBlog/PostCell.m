//
//  PostCell.m
//  iBlog
//
//  Created by Yong Su on 12/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostCell.h"
#import <QuartzCore/QuartzCore.h>

#define kNameValueTag 2

@implementation PostCell

@synthesize name;
@synthesize nameLabel;
@synthesize totalContentHeight;
@synthesize avatarImageView;
@synthesize forwardBackgroundImageView;
@synthesize contentTextView;
@synthesize forwardTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    totalContentHeight = 60.0f;
    [forwardTextView setBackgroundColor:[UIColor clearColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)n
{
    if (![n isEqualToString:name])
    {
        name = [n copy];
        nameLabel.text = name;
    }
}

@end
