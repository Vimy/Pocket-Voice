//
//  DetailViewController.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 1/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "DetailViewController.h"
#import "Pocket_Voice-Swift.h"
#import "ReadabilityManager.h"


@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textView.text = self.item.excerpt;
    [self.player setDelegate:self];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedPlayButton:(UIButton *)sender
{
    
    //http://stackoverflow.com/questions/8504620/combine-two-wav-files-in-iphone-using-objective-c
    
    NSLog(@"url: %@", self.item.url);
    ReadabilityManager *contentManager = [[ReadabilityManager alloc]init];
    [contentManager parseWebsiteForContent:self.item.url withCallback:^(BOOL success, NSString *response, NSError *error) {
        if(success)
        {
            NSLog(@"De json -- DETAILVIEWCONTROLLER:  %@", response);
           
            NSLog(@"Number of characters --DETAILVIEWCONTROLLER: %lu", (unsigned long)[response length]);
            __block NSData *audioFile;
            
            WatsonTTSManager *ttsManager = [[WatsonTTSManager alloc]init];
            [ttsManager downloadAudioFromText:response completionHandler:^(NSData * _Nonnull data)
             {
                 audioFile = data;
                 NSError *error;
                 self.player = [[AVAudioPlayer alloc] initWithData:audioFile error:&error];
                 [self.player play];
             }];
  
        }
        
    }];
        
}
  

#pragma mark - Navigation



@end


