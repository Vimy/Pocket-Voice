//
//  PocketManager.h
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 1/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PocketManager : NSObject


typedef void (^LoadPArticlesCompletionBlock)(BOOL success, NSMutableArray *response, NSError *error);
- (void)loadPocketArticlesWithCallback: (LoadPArticlesCompletionBlock)callback;

@end
