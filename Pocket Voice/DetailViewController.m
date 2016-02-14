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
@property (strong, nonatomic) IBOutlet UISlider *audioSlider;
@property (strong, nonatomic) IBOutlet UILabel *totalPlayTime;
@property (strong, nonatomic) IBOutlet UILabel *currentPlayTime;
@property (strong, nonatomic) NSMutableArray *audioResponse;
@property (nonatomic, strong) NSTimer* timer;

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
    
    self.currentPlayTime.text = @"0:01";
    
    // Customization for play slider
    self.audioSlider.minimumTrackTintColor = [UIColor blackColor];
    self.audioSlider.maximumTrackTintColor = [UIColor blackColor];
    UIImage *image = [[UIImage imageNamed:@"slider-thumb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.audioSlider setThumbImage:image forState:UIControlStateNormal];
    
    
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
               self.audioResponse = response;
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
    
    //http://stackoverflow.com/questions/22317353/concat-two-audio-files-one-after-another-ios
    
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

    [self downloadAudio:self.audioResponse];

    
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
   //https://github.com/BoltsFramework/Bolts-ObjC
     __block int runningRequests = 0;
   // __block NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    for (NSString *content in textArray)
    {
         // dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        runningRequests++;
       // NSLog(@"Number of characters --DETAILVIEWCONTROLLER: %lu", (unsigned long)[content length]);
       // NSLog(@"CONTENT :%@", content);
        [ttsManager downloadAudioFromText:content completionHandler:^(NSData * _Nonnull data)
         {
             NSLog(@"Count TextArray: %lu", (unsigned long)[textArray count]);
             NSLog(@"Ronde nummer: %i", runningRequests);
            audioData = data;
            if (!audioData)
             {
                 NSLog(@"data leeg??");
                 
             }
             else
             {
                 // NSLog(@"Inhoud: %@", [audioFiles description]);
               //  NSLog(@"Nu voegen we data toe!");
                [audioFiles addObject:audioData];
                 NSLog(@"Number of items: %lu", (unsigned long)[audioFiles count]);
                 //[dic setObject:audioData forKey:[NSNumber numberWithInt:runningRequests]];
               
                 runningRequests--;
                 if (runningRequests == 0)
                 {
//                     NSArray *sorted = [[dic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                         return [[dic objectForKey:obj1] compare:[dic objectForKey:obj2]];
//                     }];
                     
                     [self concatenateAudioFiles:audioFiles];
                     
                     
                     
                 }
             }
        //    dispatch_semaphore_signal(sema);
         }];
       
      //  dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
      
       
    }
    
    
    //http://eppz.eu/blog/uiview-from-xib/
  //  dispatch_async(serialQueue, ^{ [self concatenateAudioFiles:audioFiles];});
   
}


- (void)concatenateAudioFiles:(NSMutableArray *)audioFile
{
    NSError *error;

    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *newAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
  
    CMTime nextClipStartTime = kCMTimeZero;
    int i = 1;
    for (NSData *audioObject in audioFile)
    {
        
        NSString *storePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"audio%i.wav", i]];
        [audioObject writeToFile:storePath atomically: YES];
        NSURL *filepath = [NSURL fileURLWithPath:storePath];
        AVURLAsset *firstComponent = [[AVURLAsset alloc] initWithURL:filepath options:nil];
        NSArray *firstTrack = [firstComponent tracksWithMediaType:AVMediaTypeAudio];
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, firstComponent.duration);
        [newAudioTrack insertTimeRange:timeRange ofTrack:firstTrack.firstObject atTime:nextClipStartTime error:&error];
        nextClipStartTime = CMTimeAdd(nextClipStartTime, timeRange.duration);
        i++;
    }
    
      
    
    
    finalAudioPath = [docsDir stringByAppendingPathComponent: @"audio.m4a"];
    
    
    
    NSError *fileError;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:finalAudioPath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:finalAudioPath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", fileError.localizedDescription);
        }
    }
    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:finalAudioPath])
//    {
//        [fileManager removeItemAtPath:finalAudioPath error:&error];
//        NSError *error;
//        if ([fileManager removeItemAtPath:finalAudioPath error:&error] == NO)
//        {
//            NSLog(@"removeItemAtPath %@ error:%@", finalAudioPath, error);
//        }
//        
//    }
//    
    

    AVAssetExportSession* exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    
    exportSession.outputURL = [NSURL fileURLWithPath:finalAudioPath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
       
       
       
       [exportSession exportAsynchronouslyWithCompletionHandler:^{

        
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"%@",exportSession.error);
                break;
            case AVAssetExportSessionStatusCompleted:
                [self playAudio:finalAudioPath];
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            default:
                break;
        }
    }];
}

- (void)playAudio:(NSString *)audioFilePath
{
    
    NSError *error;
    NSLog(@"Deze file spelen we af: %@", finalAudioPath);
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:finalAudioPath] error:&error];
    [self.player prepareToPlay];
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    

}

- (void)updateSlider
{
    NSTimeInterval currentTime = self.player.currentTime;
    NSString* currentTimeString = [NSString stringWithFormat:@"%.02f", currentTime];
    
    self.audioSlider.minimumValue = 0.0f;
    self.audioSlider.value = currentTime;
    self.audioSlider.maximumValue = self.player.duration;
    self.currentPlayTime.text =  currentTimeString;
    self.totalPlayTime.text = [NSString stringWithFormat:@"%.02f", self.player.duration - currentTime];
}

- (void)timerFired:(NSTimer*)timer
{
    [self updateSlider];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self updateSlider];
}

- (IBAction)currentTimeSliderTouchUpInside:(id)sender
{
    [self.player stop];
    NSLog(@"Slider Value: %f", self.audioSlider.value);
    self.player.currentTime = self.audioSlider.value;
    [self.player prepareToPlay];
    [self.player play];
}



- (NSString*)convertTime:(NSInteger)time
{
        NSInteger minutes = time / 60;
        NSInteger seconds = time % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%s successfully=%@", __PRETTY_FUNCTION__, flag ? @"YES"  : @"NO");
    [self stopTimer];
    [self updateSlider];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    [self stopTimer];
    [self updateSlider];
}


@end


