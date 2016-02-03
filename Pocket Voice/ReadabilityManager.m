//
//  ReadabilityManager.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 3/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "ReadabilityManager.h"
#import "AFNetworking.h"

static NSString *const baseURLString = @"https://readability.com/api/content/v1/parser?url=";
static NSString *const tokenString = @"&token=69657162b8015b6d7b1544ebe4e2dae5b8cb6fe0";


@implementation ReadabilityManager

- (void)parseWebsiteForContent:(NSString *)url withCallback:(LoadContentCompletionBlock)callback
{
    
    
 
    __block NSDictionary *jsonObject;
    
    NSString *finalURLString = [NSString stringWithFormat:@"%@%@%@", baseURLString,url,tokenString];
    NSURL *finalURL = [NSURL URLWithString:finalURLString];
    NSLog(@"url is: %@", finalURL);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
   // manager.responseSerializer = nil;
    [manager GET:finalURL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
      //  NSLog(@"ResponseObject --ReadabilityManager.h: %@",responseObject);
        jsonObject = responseObject;
        NSString *content = [self getContentFromJSON:jsonObject];
        callback(YES,content,nil);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error :%@", error);
    }];
    
    

}

- (NSString *)getContentFromJSON:(NSDictionary *)jsonDic
{
    NSString *content;
    if (jsonDic[@"content"])
    {
        content = [jsonDic valueForKey:@"content"];
    }
    else
    {
        content = @"There was an error";
    }
   // NSLog(@"Content-log ReadabilityManager.h:%@", content);
    return content;
}

@end
