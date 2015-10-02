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
    NSDictionary *pocketItemsDic;
}
@end


//https://www.readability.com/developers/api



@implementation ArticlesListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
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
    
    [[PocketAPI sharedAPI] callAPIMethod:@"post"
                          withHTTPMethod:PocketAPIHTTPMethodPOST
                               arguments:argumentDictionary
                                 handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error){
                                     pocketItemsDic = [response copy];
                                     
                                     NSLog(@"response %@", [response description]);
                                     NSLog(@"error %@", [error localizedDescription]);
                                 }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pocketItemsDic count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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