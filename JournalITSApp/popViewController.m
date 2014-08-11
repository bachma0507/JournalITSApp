//
//  popViewController.m
//  JournalITSApp
//
//  Created by Barry on 1/19/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import "popViewController.h"
#import "KeychainItemWrapper.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"


@interface popViewController ()
{
    KeychainItemWrapper *keychainItem;
}

@end

@implementation popViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkgnd2.png"]]];
    
    NSString *str = @"juliba";
    
    // Convert and print the MD5 value to the console
    NSLog(@" juliba hashed to MD5: %@", [str MD5]);
    
    
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BICSIlogin" accessGroup:nil];
    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSLog(@"Keychain password = %@", password);
    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
    NSLog(@"Keychain username = %@", username);
    if ([username isEqualToString:@""]) {
        NSLog(@"Username or password is null");
    }
    else
        {
    [self.txtUsername setText:[keychainItem objectForKey:(__bridge id)(kSecAttrAccount)]];
    //[self.txtPassword setText:[keychainItem objectForKey:(__bridge id)(kSecValueData)]];
        }
    
    
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    animated = YES;
//    
//    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BICSIlogin" accessGroup:nil];
//    NSString *password = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
//    NSLog(@"Keychain password = %@", password);
//    NSString *username = [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)];
//    NSLog(@"Keychain username = %@", username);
//    
//    BOOL isLogged = ([username length] > 0 && [password length] > 0);
//    
//    if (isLogged) {
//        [self performSegueWithIdentifier:@"login_success" sender:self];
//    }
//
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//+ (NSString *) md5:(NSString *)str {
//    const char *cStr = [str UTF8String];
//    unsigned char result[16];
//    CC_MD5( cStr, strlen(cStr), result );
//    return [NSString stringWithFormat:
//            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ]; 
//}



- (IBAction)loginClicked:(id)sender {
    
    
    
    NSInteger success = 0;
    @try {
        
        //KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BICSIlogin" accessGroup:nil];
        
        
        if([[self.txtUsername text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""] ) {
            
            [self alertStatus:@"Please enter Username and Password" :@"Sign in Failed!" :0];
            
        } else {
            
            
//            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",[self.txtUsername text],[self.txtPassword text]];
//            NSLog(@"PostData: %@",post);
            
            NSString *PW = [[NSString alloc] initWithFormat:@"%@", self.txtPassword.text];
            NSString *hashPW = [PW MD5];
            
//            NSString *post =[[NSString alloc] initWithFormat:@"Name=%@&PW=%@",[self.txtUsername text],[self.txtPassword text]];
//                        NSLog(@"PostData: %@",post);

            NSString *post =[[NSString alloc] initWithFormat:@"Name=%@&PW=%@",[self.txtUsername text],hashPW];
            //NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",[self.txtUsername text],[self.txtPassword text]];
            NSLog(@"PostData: %@",post);
            
            //NSURL *url=[NSURL URLWithString:@"https://speedyreference.com/jitslogin.php"];
            //NSURL *url=[NSURL URLWithString:@"https://speedyreference.com/jitslogin.php"];
            NSString * webURL = [[NSString alloc] initWithFormat:@"https://webservice.bicsi.org/json/reply/MobAuth?Name=%@&PW=%@", [self.txtUsername text], hashPW];
            
            
            NSURL *url=[NSURL URLWithString:webURL];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                
                success = [jsonData[@"success"] integerValue];
                NSLog(@"Success: %ld",(long)success);
                
                if(success == 1)
                {
                    NSLog(@"Login SUCCESS");
                    [keychainItem setObject:[self.txtPassword text] forKey:(__bridge id)(kSecValueData)];
                    [keychainItem setObject:[self.txtUsername text] forKey:(__bridge id)(kSecAttrAccount)];
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Sign in Failed!" :0];
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    if (success) {
        
        //[self performSegueWithIdentifier:@"login_success" sender:self];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"   bundle:nil];
        
        issuesTableViewController *it = [storyboard instantiateViewControllerWithIdentifier:@"issuesTableID" ];
        
        [self presentViewController:it animated:YES completion:NULL];
        
        //[self dismissViewControllerAnimated:YES completion:NULL];
        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    }

}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
    
}
@end
