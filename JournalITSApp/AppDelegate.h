//
//  AppDelegate.h
//  JournalITSApp
//
//  Created by Barry on 1/13/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PushIOManager/PushIOManager.h>
#import "Crittercism.h"

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate, PushIOManagerDelegate>

{
    Reachability *internetReach;
}

@property (strong, nonatomic) UIWindow *window;

@property id completionHandler;

@end
