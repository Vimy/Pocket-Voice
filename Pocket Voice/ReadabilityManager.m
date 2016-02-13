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

- (void)parseWebsiteForContent:(NSMutableArray *)url withCallback:(LoadContentCompletionBlock)callback
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
        NSMutableArray  *content = [self getContentFromJSON:jsonObject];
        callback(YES,content,nil);
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error :%@", error);
    }];
    
    

}

- (NSMutableArray *)getContentFromJSON:(NSDictionary *)jsonDic
{
    NSString *content;
    NSMutableArray *contentArray = [NSMutableArray new];
    if (jsonDic[@"content"])
    {
        content = [jsonDic valueForKey:@"content"];
        contentArray = [self splitText:content byFileSizeLimitInBytes:2500];
        
    }
    else
    {
        content = @"There was an error";
    }
   // NSLog(@"Content-log ReadabilityManager.h:%@", content);
    return contentArray;
}

- (NSMutableArray *)splitText:(NSString *)string byFileSizeLimitInBytes:(int)fileSize
{
    NSMutableArray *textArray = [NSMutableArray new];
    
    if ([string length] > fileSize)
    {
        
        while (![string isEqualToString:@""])
        {
            
            if ([string length] < fileSize)
            {
              
                [textArray addObject:[self stripHtmlFromString:string]];
                break;
            }
            else
            {
                NSString *sectionString = [string substringToIndex:fileSize];
                unichar  last = [sectionString  characterAtIndex:[sectionString  length]-1];
                int x = 0;
                NSCharacterSet *set =  [NSCharacterSet characterSetWithCharactersInString:@".?!"];
                
                while (![set characterIsMember:last])
                {
                    
                    sectionString = [string substringToIndex:(fileSize-x)];
                    last = [sectionString  characterAtIndex:[sectionString  length]-1];
                    x++;
                    
                }
                string = [string stringByReplacingOccurrencesOfString:sectionString withString:@""];
                
                [textArray addObject:[self stripHtmlFromString:sectionString]];
                
            }
        }
        
    }
    else
    {
        [textArray addObject:string];
    }
    
    
    return textArray;
}
- (NSString *)stripHtmlFromString:(NSString *)string
{
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
 
    
    NSString *finalString = [attr string];
    return finalString;
}


@end
