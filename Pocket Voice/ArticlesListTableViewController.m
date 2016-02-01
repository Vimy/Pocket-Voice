//
//  ArticlesListTableViewController.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 28/09/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "ArticlesListTableViewController.h"
#import "PocketItem.h"
#import <PocketAPI.h>
#import "DetailViewController.h"
#import "PocketManager.h"


@interface ArticlesListTableViewController ()
{
    NSMutableArray *pocketItemsArray;
    NSDictionary *pocketItemsDic;
}
@end


//https://www.readability.com/developers/api


  
@implementation ArticlesListTableViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PocketManager *manager = [[PocketManager alloc]init];

   

    [manager loadPocketArticlesWithCallback:^(BOOL success, NSMutableArray *response, NSError *error) {
        if (success)
        {
            NSLog(@"MaggieDeBlock");
            pocketItemsArray = response;
            [self.tableView reloadData];
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
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [pocketItemsArray count];
    //NSLog(@"De count is :%lu",[[pocketItemsDic valueForKey:@"list" ] count]);
   
    
    // return [[pocketItemsDic valueForKey:@"list"  ] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pocketCell" forIndexPath:indexPath];
    
    PocketItem *item = [pocketItemsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.url;
    

    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *detail = segue.destinationViewController;
        detail.item = [pocketItemsArray objectAtIndex:indexPath.row];
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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
