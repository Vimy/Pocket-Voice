//
//  PocketItem.h
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 3/10/15.
//  Copyright © 2015 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PocketItem : NSObject

@property (copy, nonatomic) NSString *excerpt;
@property (copy, nonatomic) NSString *url; //given_url
@property (copy, nonatomic) NSString *title; //resolved title
@property (copy, nonatomic) NSDate *dateAdded;
@end
