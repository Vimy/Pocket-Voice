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
@property (strong, nonatomic)   AVQueuePlayer *playerQueue;
@property (strong, nonatomic)   AVAudioPlayer *player;

@end

@implementation DetailViewController
{
    __block NSData *audioData;
    __block NSMutableArray *audioItems;
    __block NSMutableArray *audioFiles;
    NSString *finalAudioPath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.item.title;
    [self.player setDelegate:self];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = self.view.center;
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    dispatch_queue_t parseTextQueue = dispatch_queue_create("textparser", NULL);
    
    ReadabilityManager *contentManager = [[ReadabilityManager alloc]init];
    
    dispatch_async(parseTextQueue, ^{[contentManager parseWebsiteForContent:self.item.url withCallback:^(BOOL success, NSMutableArray *response, NSError *error)
    {
        if(success)
        {
           dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = [self putTextTogether:response];
            [spinner stopAnimating];
           });
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    });
    
   
  //  self.navigationController.hidesBarsOnSwipe = TRUE;
    
    
    
    //https://developer.ibm.com/answers/questions/252450/ios-error-using-text-to-speech-invalid-value-aroun.html
    //http://eppz.eu/blog/uiview-from-xib/
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

    
//    ReadabilityManager *contentManager = [[ReadabilityManager alloc]init];
//    [contentManager parseWebsiteForContent:self.item.url withCallback:^(BOOL success, NSMutableArray *response, NSError *error) {
//        if(success)
//        {
//            
//            self.textView.text = [self putTextTogether:response];
//            [self downloadAudio:response];
//           
//           
//          
//            NSLog(@"Is a great succes!");
//        }
//        else
//        {
//            NSLog(@"Error");
//        }
//    }];
}

- (NSString *)putTextTogether:(NSMutableArray *)textArray
{
    NSString *returnString= @"";
    for (NSString *string in textArray)
    {
        returnString = [returnString stringByAppendingString:string];
    }
    
    return returnString;
}

- (void)downloadAudio:(NSMutableArray *)textArray
{
    WatsonTTSManager *ttsManager = [[WatsonTTSManager alloc]init];
    
  //  dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
//    dispatch_queue_t getAudio = dispatch_queue_create("parse website content", NULL);
    dispatch_queue_t serialQueue = dispatch_queue_create("com.pocketvoice.queue", DISPATCH_QUEUE_SERIAL);

    NSLog(@"Heykes");
   
     __block int i = 1;
        for (NSString *content in textArray)
    {
         // dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSLog(@"Number of characters --DETAILVIEWCONTROLLER: %lu", (unsigned long)[content length]);
        NSLog(@"CONTENT :%@", content);
        dispatch_async(serialQueue, ^{[ttsManager downloadAudioFromText:content completionHandler:^(NSData * _Nonnull data)
         {
             NSLog(@"Count TextArray: %lu", (unsigned long)[textArray count]);
             NSLog(@"Ronde nummer: %i", i);
             audioData = data;
            if (!audioData)
             {
                 NSLog(@"data leeg??");
             }
             if (i < [textArray count])
             {
                 i++;
             }
             else
             {
                 [self concatenateAudioFiles:audioFiles];
                 //[self playAudio];
             }
             // NSLog(@"Inhoud: %@", [audioFiles description]);
             NSLog(@"Nu voegen we data toe!");
             NSLog(@"Number of items: %lu", (unsigned long)[audioFiles count]);
             [audioFiles addObject:audioData];
        //    dispatch_semaphore_signal(sema);
         }];
        });
      //  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
      
        NSLog(@"Test");
    }
    
    
    //http://eppz.eu/blog/uiview-from-xib/
  //  dispatch_async(serialQueue, ^{ [self concatenateAudioFiles:audioFiles];});
   
}


- (void)concatenateAudioFiles:(NSMutableArray *)audioFiles
{
    NSError *error;
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *newAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    // NSString *applicationDocumentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].absoluteString ;
    NSString *storePath = [docsDir stringByAppendingPathComponent:@"audio.wav"];
    
    NSUInteger count = 0;
    CMTime time;
    CMTime previousTrackDuration;
    CMTime totalTrackDuration;
       for (NSData *audioObject in audioFiles)
    {
        NSLog(@"Hallo");
        
        [audioObject writeToFile:storePath atomically: YES];
        NSURL *filepath = [NSURL fileURLWithPath:storePath];
        AVURLAsset *firstComponent = [[AVURLAsset alloc] initWithURL:filepath options:nil];
        
        
        NSArray *firstTrack = [firstComponent tracksWithMediaType:AVMediaTypeAudio];
        if (!firstTrack)
        {
            NSLog(@"lege firstTrack");
            
        }
        else
        {
            if (count == 0)
            {
                time = kCMTimeZero;
            }
            else
            {
                
                totalTrackDuration = CMTimeAdd(previousTrackDuration, firstComponent.duration);
                time = totalTrackDuration;
            }
            
            CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, firstComponent.duration);
            [newAudioTrack insertTimeRange:timeRange
                                   ofTrack:firstTrack.firstObject
                                    atTime:time
                                     error:&error];

            
            previousTrackDuration = firstComponent.duration;
        }
        count++;
      
    }
    
    finalAudioPath = [docsDir stringByAppendingPathComponent: @"audio.m4a"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:finalAudioPath])
    {
        [fileManager removeItemAtPath:finalAudioPath error:&error];
        NSError *error;
        if ([fileManager removeItemAtPath:finalAudioPath error:&error] == NO)
        {
            NSLog(@"removeItemAtPath %@ error:%@", finalAudioPath, error);
        }
        
    }
    
    

                                   AVAssetExportSession* exportSession = [AVAssetExportSession
                                                                          exportSessionWithAsset:composition
                                                                          presetName:AVAssetExportPresetAppleM4A];
                                   
                                   
                                   
                                   //This gives me an output URL to a file name that doesn't yet exist
    
    
                                   


                                   
                                   exportSession.outputURL = [NSURL fileURLWithPath:finalAudioPath];
                                   exportSession.outputFileType = AVFileTypeAppleM4A;
                                   
                                   
                                   
                                   [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"%@",exportSession.error);
                break;
            case AVAssetExportSessionStatusCompleted:
                [self playAudio];
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            default:
                break;
        }
                                   }];
}

- (void)playAudio
{
    
    NSError *error;
    NSLog(@"Deze file spelen we af: %@", finalAudioPath);
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:finalAudioPath] error:&error];
    [self.player prepareToPlay];
    [self.player play];
    
//    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsDir = [dirPaths objectAtIndex:0];
//   // NSString *applicationDocumentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject].absoluteString ;
//    NSString *storePath = [docsDir stringByAppendingPathComponent:@"audio.wav"];
//    NSLog(@"storePath: %@", storePath);
//    NSURL *filepath;
//    for (NSData *audioObject in audioFiles)
//    {
//        NSLog(@"Hallo");
//        
//        [audioObject writeToFile:storePath atomically: YES];
//        filepath = [NSURL fileURLWithPath:storePath];
//        AVPlayerItem *avItem = [AVPlayerItem playerItemWithURL:filepath];
//        [audioItems addObject:avItem];
//        
//        NSLog(@"FilePath: %@", filepath);
//        NSData *dataw = [NSData dataWithContentsOfURL:filepath];
//      //  self.player = [[AVAudioPlayer alloc]initWithData:dataw error:nil];
//       
//        
//    }
    //self.player.delegate = self;
    
//    self.player = [[AVQueuePlayer alloc]initWithItems:audioItems];
//    [self.player play];
    
  

}

#pragma mark - Navigation



@end


