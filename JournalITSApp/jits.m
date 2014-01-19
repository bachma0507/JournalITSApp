//
//  jits.m
//  TestDownload
//
//  Created by Barry on 1/14/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import "jits.h"

@implementation jits

@synthesize jitsid, url, coverimage, issue;

-(id) initWithjitsID: (NSString *) jID andCoverImage: (NSString *) jCoverImage andURL: (NSString *) jURL andIssue: (NSString *) jIssue
{
    self = [super init];
    if (self) {
        
        jitsid = jID;
        coverimage = jCoverImage;
        url = jURL;
        issue = jIssue;
        
        
    }
    return self;
}

@end
