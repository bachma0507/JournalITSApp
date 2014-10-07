//
//  FirstViewController.m
//  JournalITSApp
//
//  Created by Barry on 1/13/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import "FirstViewController.h"
#import "DownloadManager.h"
#import "jits.h"
#import "AppDelegate.h"
#import "ReaderViewController.h"
#import "jitsTableViewCell.h"
#import "Reachability.h"

@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource, DownloadManagerDelegate, ReaderViewControllerDelegate>

//@property (strong, nonatomic) DownloadManager *downloadManager;
//@property (strong, nonatomic) NSDate *startDate;
//@property (nonatomic) NSInteger downloadErrorCount;
//@property (nonatomic) NSInteger downloadSuccessCount;

@end

@implementation FirstViewController

@synthesize json, jitsArray, loginButton, imageView, jitsTextView, sortedArray;

#pragma mark Constants

#define DEMO_VIEW_CONTROLLER_PUSH FALSE

#pragma mark UIViewController methods


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSFileManager *fileManager = [NSFileManager new]; NSString *documentsPath = [ReaderDocument documentsPath];
    
    for (NSString *sourcePath in [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil]) // PDFs
    {
        NSLog(@"SOURCEPATH IS: %@", sourcePath);
        
        NSString *targetPath = [documentsPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
        
        NSLog(@"TARGETPATH IS: %@", targetPath);
        
        //[fileManager removeItemAtPath:targetPath error:NULL]; // Delete target file
        
        [fileManager copyItemAtPath:sourcePath toPath:targetPath error:NULL];
    }
    
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    
//    NSString *name = [infoDictionary objectForKey:@"CFBundleName"];
//    
//    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
//    
//    self.title = [[NSString alloc] initWithFormat:@"%@ v%@", name, version];
    
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bkgnd2.png"]]];
    
    CALayer *layer = imageView.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = 3.0f;
    layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    layer.shadowOpacity = 0.5f;
    layer.shouldRasterize = YES;
    
    [[jitsTextView layer] setBorderColor:[[UIColor colorWithRed:41/256.0 green:128/256.0 blue:185/256.0 alpha:1.0] CGColor]];
    [[jitsTextView layer] setBorderWidth:1.3];
    [[jitsTextView layer] setCornerRadius:10];
    [jitsTextView setClipsToBounds: YES];
    
    //[[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x2980b9)];
    //[[UINavigationBar appearance] setTranslucent:NO];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:25.0/255.0 green:91.0/255.0 blue:166.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    [self.navigationController.navigationBar setTranslucent:NO];

    //set back button color
//    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    
    //set back button and title text color
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    [self retrieveData];
    
//    self.downloadManager = [[DownloadManager alloc] initWithDelegate:self];
//    self.downloadManager.maxConcurrentDownloads = 4;
}

- (IBAction)readSampleIssue:(id)sender {
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSFileManager *fileManager = [NSFileManager new]; NSString *documentsPath = [ReaderDocument documentsPath];
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentsPath error:NULL];
    
    NSString *fileName = [fileList firstObject]; // Presume that the first file is a PDF
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
    NSLog(@"FILEPATH IS: %@", filePath);
    
    
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
    
    NSError *error = nil;
    
    BOOL success =[url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    if (success) {
        NSLog(@"NO ERROR EXCLUDING %@ FROM BACKUP", [url lastPathComponent]);
    }
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
    }
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
        [self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
    }
    
    
}

//-(void)rowSelected:(NSString*)str
//{
//    // self.monster = curSelection;
//    
//    if (self.listPopover != nil) {
//        [self.listPopover dismissPopoverAnimated:YES];
//    }
//    
//    // [self refresh];
//}
//
//
//- (IBAction)loginClicked:(id)sender {
//    
//    popupView = [[popViewController alloc]init];
//    self.listPopover = [[UIPopoverController alloc]initWithContentViewController:popupView];
//    [self.listPopover presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:loginButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
//    
//}

//- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                        message:msg
//                                                       delegate:self
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil, nil];
//    alertView.tag = tag;
//    [alertView show];
//    
//}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}


-(void)retrieveData
{
    
    //CHECK TO SEE IF INTERNET CONNECTION IS AVAILABLE
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    //If internet connection not available then do not delete objects
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No internet connection. Data cannot be downloaded until a connection is made." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else {
        
    //NSURL *url = [NSURL URLWithString:@"http://speedyreference.com/jits.php"];
    NSURL *url = [NSURL URLWithString:@"https://webservice.bicsi.org/json/reply/MobJournals?fetchJournal=yes"];
    NSData * data = [NSData dataWithContentsOfURL:url];
        
        NSString * dataStr = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
        NSString *newDataStr = [dataStr substringWithRange:NSMakeRange(13, [dataStr length]-13)];
        NSString *truncDataStr = [newDataStr substringToIndex:[ newDataStr length]-1 ];
        
        NSData* truncData = [truncDataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    json = [NSJSONSerialization JSONObjectWithData:truncData options:kNilOptions error:nil];
    
    //Set up array
    jitsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < json.count; i++) {
        //create object
        NSString * jID = [[json objectAtIndex:i] objectForKey:@"journID"];
        NSString * jCoverImage = [[json objectAtIndex:i] objectForKey:@"coverImg"];
        NSString * jURL = [[json objectAtIndex:i] objectForKey:@"journUrl"];
        NSString * jIssue = [[json objectAtIndex:i] objectForKey:@"journIssue"];
        NSString * jTopic = [[json objectAtIndex:i] objectForKey:@"journTopic"];
        
        
        jits * myJits = [[jits alloc] initWithjitsID: jID andCoverImage:jCoverImage andURL:jURL andIssue:jIssue andTopic:jTopic];
        
        
        //Add object to Array
        [jitsArray addObject:myJits];
        
        
        
        //NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"jitsid" ascending:NO];
        //sortedArray = [self.jitsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
        
        
    }//end for
        
        
}//end else
                   
                   
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return[jitsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DownloadCell";
    
    jitsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[jitsTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"bkgnd2.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0]];
    
    jits * jitsInstance = nil;
    
    jitsInstance = [jitsArray objectAtIndex:indexPath.row];
    
    cell.issue.text = jitsInstance.issue;
    
    cell.topic.text = jitsInstance.topic;
    
    NSString * myCoverURL = [NSString stringWithFormat:@"%@", jitsInstance.coverimage];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    
    dispatch_async(queue, ^{
    
    UIImage* myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: myCoverURL]]];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
    cell.coverimage.image = myImage;
    });
    });
        
    CALayer *layer = cell.coverimage.layer;
    layer.masksToBounds = NO;
    layer.shadowRadius = 3.0f;
    layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    layer.shadowOpacity = 0.5f;
    layer.shouldRasterize = YES;
    
    
    return cell;

}

- (void)popViewControllerDidFinish:(popViewController *)controller
{
    [self.popPopoverController dismissPopoverAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popPopoverController = nil;
}

- (IBAction)togglePopover:(id)sender
{
    if (self.popPopoverController) {
        [self.popPopoverController dismissPopoverAnimated:YES];
        self.popPopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"login_detail" sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"login_detail"]) {
        [[segue destinationViewController] setDelegate:self];
        UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.popPopoverController = popoverController;
        popoverController.delegate = self;
    }
}

//- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    UIImage *background = [UIImage imageNamed:@"cellbkgnd.jpg"];
//    
//    
//    return background;
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
