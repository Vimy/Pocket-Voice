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
    
    NSString *applicationDocumentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].absoluteString ;
    NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"audio.wav"];
    
    __block NSMutableArray *audioItems = [NSMutableArray new];
    
    
    NSLog(@"url: %@", self.item.url);
    ReadabilityManager *contentManager = [[ReadabilityManager alloc]init];
    [contentManager parseWebsiteForContent:self.item.url withCallback:^(BOOL success, NSMutableArray *response, NSError *error) {
        if(success)
        {
           // NSLog(@"De json -- DETAILVIEWCONTROLLER:  %@", response);
           
            NSString *string;
            for (NSString *content in response)
            {
                NSLog(@"Number of characters --DETAILVIEWCONTROLLER: %lu", (unsigned long)[content length]);
                NSLog(@"---------------------");
                NSLog(@"---------------------");
                NSLog(@"---------------------");
                NSLog(@"---------------------");
                NSLog(@"---------------------");
                NSLog(@"---------------------");
                NSLog(@"---------------------");
                NSLog(@"%@", content);
                string = content;
            }
            
            
        
              __block NSData *audioFile;
            WatsonTTSManager *ttsManager = [[WatsonTTSManager alloc]init];
            [ttsManager downloadAudioFromText:string completionHandler:^(NSData * _Nonnull data)
             {
                 audioFile = data;
                 NSError *error;
                 [audioFile writeToFile:storePath atomically: YES];
                 NSURL *filepath = [NSURL fileURLWithPath:storePath];
                 AVPlayerItem *player = [AVPlayerItem playerItemWithURL:filepath];
                 [audioItems addObject:player];
                 
                 
                 self.player = [[AVAudioPlayer alloc] initWithData:audioFile error:&error];
                 [self.player play];
             }];
        }
        
    }];
        
}
  

#pragma mark - Navigation



@end


