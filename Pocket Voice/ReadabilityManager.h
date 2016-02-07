//
//  ReadabilityManager.h
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 3/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ReadabilityManager : NSObject

typedef void (^LoadContentCompletionBlock)(BOOL success, NSMutableArray *response, NSError *error);
//- (void)loadPocketArticlesWithCallback: (LoadPArticlesCompletionBlock)callback;

- (void)parseWebsiteForContent:(NSString *)url withCallback:(LoadContentCompletionBlock)callback;


@end
