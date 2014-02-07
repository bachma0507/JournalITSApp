//
//  jits.h
//  TestDownload
//
//  Created by Barry on 1/14/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface jits : NSObject

@property (nonatomic, strong) NSString * coverimage;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * issue;
@property (nonatomic, strong) NSString * jitsid;
@property (nonatomic, strong) NSString * topic;

//methods
-(id) initWithjitsID: (NSString *) jID andCoverImage: (NSString *) jCoverImage andURL: (NSString *) jURL andIssue: (NSString *) jIssue andTopic: (NSString *) jTopic;

@end
