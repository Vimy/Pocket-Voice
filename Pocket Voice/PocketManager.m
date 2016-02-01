//
//  PocketManager.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 1/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "PocketManager.h"
#import <PocketAPI.h>
#import "PocketItem.h"


@implementation PocketManager
{
    NSMutableArray *pocketItemsArray;
    NSDictionary *pocketItemsDic;
}


//http://zeroheroblog.com/ios/how-to-use-blocks-as-callbacks
//http://themainthread.com/blog/2012/09/communicating-with-blocks-in-objective-c.html

- (void)loadPocketArticlesWithCallback: (LoadPArticlesCompletionBlock)callback
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
                                     //[self.tableView reloadData];
                                       callback(YES,pocketItemsArray,nil);
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



@end
