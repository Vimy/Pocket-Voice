//
//  ArticlesListTableViewController.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 28/09/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "ArticlesListTableViewController.h"
#import "PocketItem.h"
//#import "PocketAPI.h"
#import "DetailViewController.h"
#import "PocketManager.h"
#import "Pocket_Voice-Swift.h"
#import "AppDelegate.h"

@interface ArticlesListTableViewController ()
{
    NSMutableArray *pocketItemsArray;
    NSDictionary *pocketItemsDic;
    PocketManager *manager;
}
@end
//https://github.com/watson-developer-cloud/ios-sdk/blob/master/Quickstart.md

//https://www.readability.com/developers/api

//#2C577D
//#3371A9
//#31608B
//#243B50
//#192632

  //http://www.lolcolors.com/

//#282c37 zwart
//#9baec8 grijs
//#d9e1e8 lichter grijs
//#2b90d9 blauw


@implementation ArticlesListTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
   // AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
   // appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];


//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    self.navigationController.navigationBar.barTintColor = [UIColor hex:@"#2b90d9"];
    self.navigationController.navigationBar.tintColor = [UIColor hex:@"#d9e1e8"];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor hex:@"#d9e1e8"]}];
        self.navigationController.navigationBar.translucent = NO;
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

    
    //self.navigationController.navigationBar.barTintColor = [UIColor hex:@"#2C577D"];
    //self.tableView.backgroundColor = [UIColor hex:@"#31608B"];;
  
//    UIColor.hex
//    
//    UIColor *color = https://github.com/hyperoslo/Hue
    //self.navigationController.hidesBarsOnSwipe = TRUE;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor grayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadData)
                  forControlEvents:UIControlEventValueChanged];
    
    
    
    dispatch_queue_t downloadArticles = dispatch_queue_create("downloadArticles", NULL);
    dispatch_async(downloadArticles, ^{
        manager = [[PocketManager alloc]init];
        [manager loadPocketArticlesWithCallback:^(BOOL success, NSMutableArray *response, NSError *error) {
            if (success)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"Maggie^Block");
                    pocketItemsArray = response;
                    [spinner stopAnimating];
                    [self.tableView reloadData];
                });
  
            }
            else
            {
                UIAlertController *warning = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"Couldn't load Pocket Articles."
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction
                                     actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * _Nonnull action) {
                                         [warning dismissViewControllerAnimated:YES completion:nil];
                                     }];
                [warning addAction:ok];
                [self presentViewController:warning animated:YES completion:nil];
            }
        }];

    });
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)prefersStatusBarHidden
{
    if (self.navigationController.navigationBarHidden == true)
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData
{
    [manager reloadPocketArticlesWithCallback:^(BOOL success, NSMutableArray *response, NSError *error) {
        if (success)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"reloading");
                pocketItemsArray = response;
                [self.tableView reloadData];
            });
            
        }
        else
        {
            UIAlertController *warning = [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:@"Couldn't load Pocket Articles."
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * _Nonnull action) {
                                     [warning dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [warning addAction:ok];
            [self presentViewController:warning animated:YES completion:nil];
        }

    }];
    

    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    if(pocketItemsArray)
    {
        messageLabel.hidden = YES;
        return 1;
    }
    else
    {
        
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
   return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [pocketItemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pocketCell" forIndexPath:indexPath];
    
    PocketItem *item = [pocketItemsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.domain;
    cell.backgroundColor = [UIColor hex:@"#282c37"];
    cell.textLabel.textColor = [UIColor hex:@"#9baec8"];
    cell.detailTextLabel.textColor = [UIColor hex:@"#d9e1e8"];
    return cell;
}
//#2C577D
//#3371A9
//#31608B
//#243B50
//#192632

#pragma mark - UI settings

//https://www.hackingwithswift.com/read/32/2/automatically-resizing-uitableviewcells-with-dynamic-type-and-ns

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *detail = segue.destinationViewController;
        detail.item = [pocketItemsArray objectAtIndex:indexPath.row];
     
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
