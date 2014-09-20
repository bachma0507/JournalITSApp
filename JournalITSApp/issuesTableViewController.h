//
//  issuesTableViewController.h
//  JournalITSApp
//
//  Created by Barry on 1/19/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class issuesTableViewController;

@protocol issuesTableViewControllerDelegate

@end

//@class MBProgressHUD;

@interface issuesTableViewController : UITableViewController
//{
//    MBProgressHUD *HUD;
//}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) id <issuesTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray * json;
@property (nonatomic, strong) NSMutableArray * jitsArray;
@property (nonatomic, strong) NSArray * sortedArray;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;




-(void) retrieveData;

@end
