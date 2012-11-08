//
//  CommentViewController.h
//  iBlog
//
//  Created by Yong Su on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIView *navigationView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UITextView *commentTextField;
@property (strong, nonatomic) IBOutlet UIView *netBar;

- (IBAction)onCancelButtonClicked:(id)sender;

@end
