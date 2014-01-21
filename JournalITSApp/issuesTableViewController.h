//
//  issuesTableViewController.h
//  JournalITSApp
//
//  Created by Barry on 1/19/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface issuesTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;


@property (nonatomic, strong) NSMutableArray * json;
@property (nonatomic, strong) NSMutableArray * jitsArray;
@property (nonatomic, strong) NSArray * sortedArray;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;



-(void) retrieveData;

@end
