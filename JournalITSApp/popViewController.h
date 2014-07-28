//
//  popViewController.h
//  JournalITSApp
//
//  Created by Barry on 1/19/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "issuesTableViewController.h"

@class popViewController;

@protocol popViewControllerDelegate
- (void)popViewControllerDidFinish:(popViewController *)controller;


@end

@interface popViewController : UIViewController<issuesTableViewControllerDelegate>
@property (weak, nonatomic) id <popViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)loginClicked:(id)sender;



@end
