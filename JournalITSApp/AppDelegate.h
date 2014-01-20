//
//  AppDelegate.h
//  JournalITSApp
//
//  Created by Barry on 1/13/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    Reachability *internetReach;
}

@property (strong, nonatomic) UIWindow *window;

@property id completionHandler;

@end
