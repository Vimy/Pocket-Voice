//
//  PocketItem.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 3/10/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import "PocketItem.h"

@implementation PocketItem

- (NSString *)title
{
    if ([_title isEqualToString:@""])
    {
        _title = @"[Article without Title]";
    }
    
    return _title;
}

@end
