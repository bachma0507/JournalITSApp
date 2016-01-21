//
//  issuesTableViewController.m
//  JournalITSApp
//
//  Created by Barry on 1/19/14.
//  Copyright (c) 2014 BICSI. All rights reserved.
//

#import "issuesTableViewController.h"
#import "DownloadManager.h"
#import "jitsTableViewCell.h"
#import "jits.h"
#import "AppDelegate.h"
#import "ReaderViewController.h"
//#import "MBProgressHUD.h"

@interface issuesTableViewController () <DownloadManagerDelegate, ReaderViewControllerDelegate>

@property (strong, nonatomic) DownloadManager *downloadManager;
@property (strong, nonatomic) NSDate *startDate;
@property (nonatomic) NSInteger downloadErrorCount;
@property (nonatomic) NSInteger downloadSuccessCount;


@end

@implementation issuesTableViewController

@synthesize json, jitsArray, progressView, sortedArray, cancelButton;

#pragma mark Constants

#define DEMO_VIEW_CONTROLLER_PUSH FALSE

#pragma mark UIViewController methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self retrieveData];
    
    self.downloadManager = [[DownloadManager alloc] initWithDelegate:self];
    self.downloadManager.maxConcurrentDownloads = 10;
    
    self.cancelButton.enabled = NO;
    
    
    
    [progressView setHidden:YES];
    
    [self.navigationItem setHidesBackButton:YES];
    
    
}

- (void)waitForSevenSeconds {
    sleep(7);
}

-(void)retrieveData
{
    
//    NSURL *url = [NSURL URLWithString:@"http://speedyreference.com/jits.php"];
//    NSData * data = [NSData dataWithContentsOfURL:url];
//    
//    
//    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    
//    
//    //Set up array
//    jitsArray = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < json.count; i++) {
//        //create object
//        NSString * jID = [[json objectAtIndex:i] objectForKey:@"ID"];
//        NSString * jCoverImage = [[json objectAtIndex:i] objectForKey:@"COVERIMAGE"];
//        NSString * jURL = [[json objectAtIndex:i] objectForKey:@"URL"];
//        NSString * jIssue = [[json objectAtIndex:i] objectForKey:@"ISSUE"];
//        NSString * jTopic = [[json objectAtIndex:i] objectForKey:@"TOPIC"];
    
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
        
        //NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"jitsid" ascending:YES];
        //sortedArray = [self.jitsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - DownloadManager Delegate Methods

// optional method to indicate completion of all downloads
//
// In this view controller, display message

- (void)didFinishLoadingAllForManager:(DownloadManager *)downloadManager
{
    //    NSString *message;
    //
    //    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:self.startDate];
    //
    self.cancelButton.enabled = NO;
    //
    //    if (self.downloadErrorCount == 0)
    //    {
    //        message = [NSString stringWithFormat:@"%d file(s) downloaded successfully. The files are located in the app's Documents folder on your device/simulator. (%.1f seconds)", self.downloadSuccessCount, elapsed];
    //    }
    //
    //    else
    //    {
    //        message = [NSString stringWithFormat:@"%d file(s) downloaded successfully. %d file(s) were not downloaded successfully. (%.1f seconds)", self.downloadSuccessCount, self.downloadErrorCount, elapsed];
    //
    //    [[[UIAlertView alloc] initWithTitle:nil
    //                                message:message
    //                               delegate:nil
    //                      cancelButtonTitle:@"OK"
    //                      otherButtonTitles:nil] show];
    //    }
}

// optional method to indicate that individual download completed successfully
//
// In this view controller, I'll keep track of a counter for entertainment purposes and update
// tableview that's showing a list of the current downloads.

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFinishLoading:(Download *)download;
{
    self.downloadSuccessCount++;
    
    [self.tableView reloadData];
}

// optional method to indicate that individual download failed
//
// In this view controller, I'll keep track of a counter for entertainment purposes and update
// tableview that's showing a list of the current downloads.

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidFail:(Download *)download;
{
    NSLog(@"%s %@ error=%@", __FUNCTION__, download.filename, download.error);
    
    self.downloadErrorCount++;
    
    [self.tableView reloadData];
}

// optional method to indicate progress of individual download
//
// In this view controller, I'll update progress indicator for the download.

- (void)downloadManager:(DownloadManager *)downloadManager downloadDidReceiveData:(Download *)download;
{
    
    for (NSInteger row = 0; row < [downloadManager.downloads count]; row++)
        
    {
        if (download == downloadManager.downloads[row])
        {
            [self updateProgressViewForIndexPath:[NSIndexPath indexPathForRow:row inSection:0] download:download];
            
        }
        
        break;
        
    }
    
    
}

#pragma mark - Table View delegate and data source methods

// our table view will simply display a list of files being downloaded

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return[jitsArray count];
    
    NSLog(@"jitsArray count = %lu", (unsigned long)jitsArray.count);
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
    
    NSLog(@"jitsid = %@", jitsInstance.jitsid);
    
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
    
    [progressView setProgress:0];
    [progressView setHidden:YES];
    
    
    NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
    
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
    
    NSURL *url = [NSURL fileURLWithPath:downloadFolder];
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    NSString * fileName = [[NSString alloc]initWithFormat:@"%@", [myURL lastPathComponent]];
    
    NSString* foofile = [downloadFolder stringByAppendingPathComponent:fileName];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    
    NSLog(@"Search file path: %@", foofile);
    
    if (!fileExists) {
        cell.TapLabel.text = @"Tap to Download";
        cell.TapLabel.alpha = 1.0;
        
        NSLog(@"File does not exist!");
        
    }
    else if (fileExists){
        NSLog(@"File exist!");
        cell.TapLabel.text = @"Tap to Read";
        cell.TapLabel.font = [UIFont systemFontOfSize:17.0];
        cell.TapLabel.textColor = [UIColor whiteColor];
        cell.TapLabel.alpha = 1.0;
        cell.TapLabel.hidden = NO;
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:76 green:161 blue:255 alpha:0];
    
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithRed:121/255.0 green:184/255.0 blue:255/255.0 alpha:1.0];
        cell.backgroundColor = altCellColor;
    }
}

//- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    UIImage *background = [UIImage imageNamed:@"bkgnd2.png"];
//        return background;
//}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    jitsTableViewCell *cell = (jitsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.TapLabel.text isEqual: @"Tap to Download"]) {
        
        
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
        
        jits * jitsInstance = nil;
        
        jitsInstance = [jitsArray objectAtIndex:indexPath.row];
        
        NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
        
        
        NSString *downloadFilename = [downloadFolder stringByAppendingPathComponent:[myURL lastPathComponent]];
        NSURL *url = [NSURL URLWithString:myURL];
        
        NSLog(@"downloadFilename is:%@", downloadFilename);
        
        [self.downloadManager addDownloadWithFilename:downloadFilename URL:url];
        
        
        self.cancelButton.enabled = YES;
        self.cancelButton.tintColor = [UIColor redColor];
        [progressView setHidden:NO];
        self.startDate = [NSDate date];
        //cell.TapLabel.hidden = YES;
        cell.TapLabel.text = @"Downloading...";
        cell.TapLabel.textColor = [UIColor colorWithRed:243 green:156 blue:18 alpha:1];
        cell.TapLabel.font = [UIFont systemFontOfSize:17.0];
        
        //        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        //        HUD.labelText = @"Downloading...";
        //        //HUD.detailsLabelText = @"Just relax";
        //        HUD.mode = MBProgressHUDAnimationFade;
        //        //HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
        //        [self.view addSubview:HUD];
        //        [HUD showWhileExecuting:@selector(waitForSevenSeconds) onTarget:self withObject:nil animated:YES];
        
        
        [self.downloadManager start];
        
        
    }
    else if ([cell.TapLabel.text isEqual: @"Tap to Read"])
    {
        
        jits * jitsInstance = nil;
        
        jitsInstance = [jitsArray objectAtIndex:indexPath.row];
        
        NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
        
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
        
        NSString * fileName = [[NSString alloc]initWithFormat:@"%@", [myURL lastPathComponent]];
        
        NSString* foofile = [downloadFolder stringByAppendingPathComponent:fileName];
        
        NSLog(@"foofile path is:%@", foofile);
        
        NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:foofile password:phrase];
        
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
    
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        
        //}
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        jits * jitsInstance = nil;
        
        jitsInstance = [jitsArray objectAtIndex:indexPath.row];
        
        NSString * myURL = [NSString stringWithFormat:@"%@", jitsInstance.url];
        
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *downloadFolder = [documentsPath stringByAppendingPathComponent:@"downloads"];
        
        NSString * fileName = [[NSString alloc]initWithFormat:@"%@", [myURL lastPathComponent]];
        
        NSString* foofile = [downloadFolder stringByAppendingPathComponent:fileName];
        
        NSError *error;
        
        BOOL success =[fileManager removeItemAtPath:foofile error:&error];
        if (success) {
            UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Notification:" message:@"File has been deleted from your device." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [removeSuccessFulAlert show];
            
        }
        else
        {
            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
        }
        
        
    }
    jitsTableViewCell *cell = (jitsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.TapLabel.text isEqual: @"Tap to Download"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Notification:" message:@"File has not been downloaded and therefore cannot be deleted." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        
    }
    else{
        NSMutableArray *array = [self.jitsArray mutableCopy];
        [array removeObjectAtIndex:indexPath.row];
        self.jitsArray = array;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - Table view utility methods

- (void)updateProgressViewForIndexPath:(NSIndexPath *)indexPath download:(Download *)download
{
    
    jitsTableViewCell *cell = (jitsTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    
    // if the cell is not visible, we can return
    
    if (!cell)
        return;
    
    if (download.expectedContentLength >= 0)
    {
        // if the server was able to tell us the length of the file, then update progress view appropriately
        // to reflect what % of the file has been downloaded
        
        progressView.progress = (double) download.progressContentLength / (double) download.expectedContentLength;
    }
    else
    {
        // if the server was unable to tell us the length of the file, we'll change the progress view, but
        // it will just spin around and around, not really telling us the progress of the complete download,
        // but at least we get some progress update as bytes are downloaded.
        //
        // This progress view will just be what % of the current megabyte has been downloaded
        
        progressView.progress = (double) (download.progressContentLength % 1000000L) / 1000000.0;
    }
}

#pragma mark - IBAction methods

- (IBAction)tappedCancelButton:(id)sender
{
    [self.downloadManager cancelAll];
}

@end
