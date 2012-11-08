//
//  PostCell.h
//  iBlog
//
//  Created by Yong Su on 12/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property float totalContentHeight;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *forwardBackgroundImageView;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UITextView *forwardTextView;

@end
