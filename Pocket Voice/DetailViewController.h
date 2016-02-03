//
//  DetailViewController.h
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 1/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PocketItem.h"
@import WatsonDeveloperCloud;

@interface DetailViewController : UIViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) PocketItem *item;

@end
