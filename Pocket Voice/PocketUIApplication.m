//
//  PocketUIApplication.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 17/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "PocketUIApplication.h"

@implementation PocketUIApplication
//https://github.com/Pocket/Pocket-ObjC-SDK/pull/10
- (BOOL)openURL:(NSURL*)url
{
    NSLog(@"Open url: %@", url);
    
    
    
    NSString *string = url.absoluteString;
    NSString *substring = @"pocketapp46280:///login";
    
    if ([string localizedCaseInsensitiveContainsString:substring])
    {
        NSString *urlString = [string stringByReplacingOccurrencesOfString:@"pocketapp46280:///login/?url=" withString:@""];
        NSLog(@"URLSFDSSTRING :%@", urlString);

        NSString *finalString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"FINALSTRING :%@", finalString);
        NSDictionary *dic = @{@"url":finalString};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pocketLoginSafarisNeeded" object:dic];
        return NO;
    }
    
    return [super openURL:url];
}
@end
