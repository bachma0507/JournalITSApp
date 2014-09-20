//
//  jitsTableViewCell.h
//  JournalITSApp
//
//  Created by Barry on 1/19/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jitsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *issue;
@property (nonatomic, strong) IBOutlet UILabel *topic;
@property (nonatomic, strong) IBOutlet UIImageView *coverimage;
@property (strong, nonatomic) IBOutlet UILabel *TapLabel;



@end
