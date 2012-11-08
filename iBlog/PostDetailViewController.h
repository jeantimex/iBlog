//
//  PostDetailViewController.h
//  iBlog
//
//  Created by Yong Su on 11/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"

@interface PostDetailViewController : UIViewController <UIActionSheetDelegate>/*<UITabBarDelegate>*/

@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) NSString *postSelected;

@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@property (strong, nonatomic) IBOutlet UIButton *bookmarkButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UIImageView *forwardBackgroundImageView;


- (IBAction)onRefreshButtonClicked:(id)sender;
- (IBAction)onCommentButtonClicked:(id)sender;
- (IBAction)onForwardButtonClicked:(id)sender;
- (IBAction)onBookmarkButtonClicked:(id)sender;
- (IBAction)onMoreButtonClicked:(id)sender;

@end
