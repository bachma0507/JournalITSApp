//
//  FirstViewController.h
//  JournalITSApp
//
//  Created by Barry on 1/13/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * json;
@property (nonatomic, strong) NSMutableArray * jitsArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)readSampleIssue:(id)sender;

-(void) retrieveData;

@end
