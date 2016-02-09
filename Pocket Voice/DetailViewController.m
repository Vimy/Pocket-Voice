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
    
    __block NSData *audioData;
    __block NSMutableArray *audioItems = [NSMutableArray new];
     __block NSMutableArray *audioFiles = [NSMutableArray new];
    
    
    
    NSLog(@"url: %@", self.item.url);
    
     dispatch_queue_t queue = dispatch_queue_create("audio fetcher", NULL);
    
    //dispatch_async(queue, ^{
        ReadabilityManager *contentManager = [[ReadabilityManager alloc]init];
    [contentManager parseWebsiteForContent:self.item.url withCallback:^(BOOL success, NSMutableArray *response, NSError *error) {
        if(success)
        {
         
            WatsonTTSManager *ttsManager = [[WatsonTTSManager alloc]init];
           
            
            for (NSString *content in response)
            {
                
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    
                NSLog(@"Number of characters --DETAILVIEWCONTROLLER: %lu", (unsigned long)[content length]);
       
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @autoreleasepool
                    {
                        [ttsManager downloadAudioFromText:@"Hoi" completionHandler:^(NSData * _Nonnull data)
                         {
                             
                             audioData = data;
                             if (!audioData)
                             {
                                 NSLog(@"data leeg??");
                             }
                             [audioFiles addObject:audioData];
                            // NSLog(@"Inhoud: %@", [audioFiles description]);
                             NSLog(@"Nu voegen we data toe!");
                             NSLog(@"Number of items: %lu", (unsigned long)[audioFiles count]);
                             
                             
                         }];
                    }
      
                     dispatch_semaphore_signal(semaphore);
                });
                
          
                
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
       
              
                
                for (NSData *audioObject in audioFiles)
                {
                    NSLog(@"Hallo");
                    
                    [audioObject writeToFile:storePath atomically: YES];
                    NSURL *filepath = [NSURL fileURLWithPath:storePath];
                    AVPlayerItem *avItem = [AVPlayerItem playerItemWithURL:filepath];
                    [audioItems addObject:avItem];
                }
                
                AVQueuePlayer *player = [[AVQueuePlayer alloc]initWithItems:audioItems];
                [player play];
                
                dispatch_semaphore_signal(semaphore);
            }
            
         

     
            
//
//            self.player = [[AVAudioPlayer alloc] initWithData:audioFile error:&error];
//            [self.player play];
            
        
          
                              
            
    
        }
        
        
    }];
// dispatch_sync(dispatch_get_main_queue(), ^{
//    
// });
   // });
}


#pragma mark - Navigation



@end


