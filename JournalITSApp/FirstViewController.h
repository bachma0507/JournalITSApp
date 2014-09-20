//
//  FirstViewController.h
//  JournalITSApp
//
//  Created by Barry on 1/13/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "popViewController.h"

@class Reachability;

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, popViewControllerDelegate, UIPopoverControllerDelegate>

{
    popViewController *popupView;
    Reachability *internetReach;
    
}

@property (strong, nonatomic) UIPopoverController *popPopoverController;
@property (nonatomic, strong) NSMutableArray * json;
@property (nonatomic, strong) NSMutableArray * jitsArray;
@property (nonatomic, strong) NSArray * sortedArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, retain) UIPopoverController *listPopover;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *jitsTextView;
- (IBAction)readSampleIssue:(id)sender;
//- (IBAction)loginClicked:(id)sender;

-(void) retrieveData;

@end
