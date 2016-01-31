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
    
    [self loadPocketArticles];
    
    [self.tableView reloadData];
    
    if([[PocketAPI sharedAPI] isLoggedIn])
    {
        NSLog(@"We zijn ingelogd!");
    }
    else
    {
        NSLog(@"We zijn niet ingelogd!");
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadPocketArticles
{
    
    NSError* errorJSON;
    NSArray *actions = @[@{ @"count": @"10", @"detailType": @"complete" }];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: actions
                                                       options: kNilOptions
                                                         error: &errorJSON];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding: NSUTF8StringEncoding];
    
    NSDictionary* argumentDictionary = @{@"actions":jsonString};
    
    
    [[PocketAPI sharedAPI] callAPIMethod:@"get"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:argumentDictionary
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error){
                                     pocketItemsDic = [response valueForKeyPath:@"list"];

                                     NSArray *keys = [pocketItemsDic allKeys];
                                     NSLog(@"Keyz: %@", keys);
                                     
                                      pocketItemsArray = [NSMutableArray array];
                                     for (id key in keys)
                                     {
                                         NSDictionary *ArticleDic = [pocketItemsDic valueForKey:key];
                                         NSLog(@"Dit is de dic: %@", ArticleDic);
                                         [pocketItemsArray addObject:[ArticleDic valueForKeyPath:@"given_title"]];
                                         
                                     }
                                     
                                     [self.tableView reloadData];
                                    
                                                                    }];
    
    
    //http://blog.mobilejazz.com/ios-using-kvc-to-parse-json/

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
    
    
    cell.textLabel.text = [pocketItemsArray objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"subtext test";
    

    
    return cell;
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
