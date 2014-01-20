//
//  popViewController.h
//  JournalITSApp
//
//  Created by Barry on 1/19/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)loginClicked:(id)sender;

@end
