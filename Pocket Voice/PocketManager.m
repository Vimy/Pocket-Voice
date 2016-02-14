//
//  PocketManager.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 1/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "PocketManager.h"
#import "PocketAPI.h"
#import "PocketItem.h"


@implementation PocketManager
{
    NSMutableArray *pocketItemsArray;
    NSDictionary *pocketItemsDic;
    NSString *path;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        path = [documentsDirectory stringByAppendingPathComponent:@"PocketArticles.json"];
    }
    return self;
}
//http://zeroheroblog.com/ios/how-to-use-blocks-as-callbacks
//http://themainthread.com/blog/2012/09/communicating-with-blocks-in-objective-c.html

- (void)loadPocketArticlesWithCallback:(LoadPArticlesCompletionBlock)callback
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
   
        if ([fileManager fileExistsAtPath: path])
        {
            pocketItemsArray= [self returnJSONFromFile];
            NSLog(@"File Exists");
            callback(YES,pocketItemsArray,nil);
        }
        else
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
                                         handler:^(PocketAPI *api, NSString *apiMethod, NSDictionary *response, NSError *error)
                                        {
                                             
                                             pocketItemsArray = [self putJSONInObjects:response];
                                            
                                            NSError * err;
                                            NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:response options:0 error:&err];
                                            NSString * jsonString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
                                            [self writeStringToFile:jsonString];
                                             callback(YES,pocketItemsArray,nil);
                                          
                                         }];
        }
        
    

    
    
    
    
    
    
    
    
    
    
    
    
        //http://blog.mobilejazz.com/ios-using-kvc-to-parse-json/
    
  
    
    
    
    
    
}

- (NSMutableArray *)putJSONInObjects:(NSDictionary *)response
{
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
        item.domain = [self getDomainFromUrlString:[ArticleDic valueForKeyPath:@"given_url"]];
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
    
    return pocketItemsArray;

}

- (NSMutableArray *)returnJSONFromFile
{
    NSLog(@"Stringie");
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *arr = [self putJSONInObjects:json];
    
    return arr;
    
}



- (void)writeStringToFile:(NSString*)aString {
    
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path ])
    {
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    }
    
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path  atomically:NO];
}

- (NSString *)getDomainFromUrlString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *domain = [url host];
    return domain;
    
}

- (NSDate*)getDateFromUnixTimeStamp:(double)timeStamp
{
    double unixTimeStamp =timeStamp;
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    return date;
}



@end
