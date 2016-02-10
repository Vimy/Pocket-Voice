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
{
    __block NSData *audioData;
    __block NSMutableArray *audioItems;
    __block NSMutableArray *audioFiles;
 
}

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
  
    
    
    audioItems = [NSMutableArray new];
    audioFiles = [NSMutableArray new];
    NSLog(@"url: %@", self.item.url);

  //  dispatch_queue_t getContent = dispatch_queue_create("parse website content", NULL);

    
    ReadabilityManager *contentManager = [[ReadabilityManager alloc]init];
    [contentManager parseWebsiteForContent:self.item.url withCallback:^(BOOL success, NSMutableArray *response, NSError *error) {
        if(success)
        {
            
                [self downloadAudio:response];
           
           
          
            NSLog(@"Is a great succes!");
        }
        else
        {
            NSLog(@"Error");
        }
    }];
}

- (void)downloadAudio:(NSMutableArray *)textArray
{
    WatsonTTSManager *ttsManager = [[WatsonTTSManager alloc]init];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_queue_t getAudio = dispatch_queue_create("parse website content", NULL);
    dispatch_queue_t serialQueue = dispatch_queue_create("com.pocketvoice.queue", DISPATCH_QUEUE_SERIAL);

    NSLog(@"Heykes");
   
     __block int i = 1;
        for (NSString *content in textArray)
    {
        //  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSLog(@"Number of characters --DETAILVIEWCONTROLLER: %lu", (unsigned long)[content length]);
        NSLog(@"CONTENT :%@", content);
        dispatch_async(serialQueue, ^{[ttsManager downloadAudioFromText:content completionHandler:^(NSData * _Nonnull data)
         {
             audioData = data;
             if (!audioData)
             {
                 NSLog(@"data leeg??");
             }
             if (i < [textArray count])
             {
                 i += 1;
             }
             else
             {
                 [self playAudio];
             }
             // NSLog(@"Inhoud: %@", [audioFiles description]);
             NSLog(@"Nu voegen we data toe!");
             NSLog(@"Number of items: %lu", (unsigned long)[audioFiles count]);
             [audioFiles addObject:audioData];
           // dispatch_semaphore_signal(sema);
         }];
        });
       // dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
      
        NSLog(@"Test");
    }
    
    
}


- (void)playAudio
{
    
    NSString *applicationDocumentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].absoluteString ;
    NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"audio.wav"];
    
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

}

#pragma mark - Navigation



@end


