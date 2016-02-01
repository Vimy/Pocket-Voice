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
                                     NSMutableArray *pocketItemsUnsorted = [NSMutableArray new];
                                     for (id key in keys)
                                     {
                                         NSDictionary *ArticleDic = [pocketItemsDic valueForKey:key];
                                         NSLog(@"Dit is de dic: %@", ArticleDic);
                                         //[pocketItemsArray addObject:[ArticleDic valueForKeyPath:@"given_title"]];
                                         PocketItem *item = [[PocketItem alloc]init];
                                         item.url = [ArticleDic valueForKeyPath:@"given_url"];
                                         item.title = [ArticleDic valueForKeyPath:@"resolved_title"];
                                         item.excerpt = [ArticleDic valueForKeyPath:@"excerpt"];
                                         double timestamp = [[ArticleDic valueForKeyPath:@"time_added"]doubleValue];
                                         item.dateAdded = [self getDateFromUnixTimeStamp:timestamp];
                                         [pocketItemsUnsorted addObject:item];
                                     }
                                     
                                     //artikels sorten op datum
                                     NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                                         sortDescriptorWithKey:@"dateAdded"
                                                                         ascending:NO];
                                     NSMutableArray *sortDescriptors = [[NSMutableArray alloc]initWithObjects:dateDescriptor, nil];
                                     pocketItemsArray = (NSMutableArray *)[pocketItemsUnsorted
                                                                  sortedArrayUsingDescriptors:sortDescriptors];
                                     [self.tableView reloadData];
                                    
                                                                    }];
    //http://blog.mobilejazz.com/ios-using-kvc-to-parse-json/

}


- (NSDate*)getDateFromUnixTimeStamp:(double)timeStamp
{
    double unixTimeStamp =timeStamp;
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
//    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
//    [formatter setLocale:[NSLocale currentLocale]];
//    [formatter setDateFormat:@"dd.MM.yyyy"];
//    NSString *dateString = [formatter stringFromDate:date];
    return date;
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
