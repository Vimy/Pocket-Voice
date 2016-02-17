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
#import "AudioControlsView.h"



@interface DetailViewController ()


@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSMutableArray *audioResponse;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong)  AudioControlsView *audioView;
@property (nonatomic, strong) SwiftSpinner *swiftySpinner;
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
    self.automaticallyAdjustsScrollViewInsets = NO ;//textview has whitespace otherwise

    
    
    
    
    
    
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


- (IBAction)playButtonTapped:(UIBarButtonItem *)sender
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
    _swiftySpinner = [SwiftSpinner new];
    [SwiftSpinner show:@"Generating audio" animated:YES];

//    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsDir = [dirPaths objectAtIndex:0];
    
//    finalAudioPath = [docsDir stringByAppendingPathComponent: @"audio.m4a"];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:finalAudioPath])
//    {
//        [self playAudio:finalAudioPath];
//    }
//    else
//    {
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    WatsonTTSManager *ttsManager = [[WatsonTTSManager alloc]init];

   //https://github.com/BoltsFramework/Bolts-ObjC
    //http://stackoverflow.com/questions/34212022/downloading-images-asynchronously-in-sequence?rq=1
    
    dispatch_group_t group = dispatch_group_create();
    for (NSString *content in textArray)
    {
        dispatch_group_enter(group);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
         [ttsManager downloadAudioFromText:content completionHandler:^(NSData * _Nonnull data)
         {

            audioData = data;
            if (!audioData)
             {
                 NSLog(@"data leeg??");
             }
             else
             {
                [audioFiles addObject:audioData];
                 NSLog(@"Number of items: %lu", (unsigned long)[audioFiles count]);
             }
                dispatch_semaphore_signal(semaphore);
                dispatch_group_leave(group);
           
         }];
           dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    

        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"Leaving the dispatch group");
            [self concatenateAudioFiles:audioFiles];
            
        });

   });
    
  //  }
    
    //http://eppz.eu/blog/uiview-from-xib/
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
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:finalAudioPath])
    {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:finalAudioPath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", fileError.localizedDescription);
        }
    }
    

    AVAssetExportSession* exportSession = [AVAssetExportSession
                                           exportSessionWithAsset:composition
                                           presetName:AVAssetExportPresetAppleM4A];
    
    exportSession.outputURL = [NSURL fileURLWithPath:finalAudioPath];
    exportSession.outputFileType = AVFileTypeAppleM4A;
       
       
       
       [exportSession exportAsynchronouslyWithCompletionHandler:^{

           if (exportSession.status ==AVAssetExportSessionStatusFailed )
           {
                NSLog(@"%@",exportSession.error);
           }
           else if (exportSession.status == AVAssetExportSessionStatusCompleted)
           {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [self playAudio:finalAudioPath];
               });
           }
           else if (exportSession.status == AVAssetExportSessionStatusWaiting)
           {
               NSLog(@"Waiting on export audiofile");
           }
        
    }];
}

- (void)playAudio:(NSString *)audioURLString
{
    
    [SwiftSpinner hide:^{
        NSLog(@"Gedaan met wachten! Einde animatie");
    }];
    NSURL *audioURL = [NSURL URLWithString:audioURLString];
    
    
    
    self.audioView = [[[NSBundle mainBundle] loadNibNamed:@"AudioControlView"
                                                             owner:self
                                                           options:nil] objectAtIndex:0];
    if (self.audioView)
    {
        self.audioView.fileURL = audioURL;
    }
    
   self.audioView.frame = CGRectMake(0,self.view.bounds.size.height+self.audioView.frame.size.height, self.view.bounds.size.width, 70);
   // audioView.frame= CGRectMake(0,300 , self.view.frame.size.width, 70);
    self.audioView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.audioView];
    [self showViewAnimation];
    
}

- (void)showViewAnimation
{
    [UIView animateWithDuration:0.8 animations:^{
        self.audioView.frame = CGRectMake(0,self.view.bounds.size.height-self.audioView.frame.size.height, self.view.bounds.size.width, 70);
    } completion:^(BOOL finished) {
        NSLog(@"Animatie geslaagd!");
        [self.audioView play:self];
    }];
}

- (void)hideViewAnimation
{
    
    [UIView animateWithDuration:0.8 animations:^{
        self.audioView.frame = CGRectMake(0,self.view.bounds.size.height+self.audioView.frame.size.height, self.view.bounds.size.width, 70);
    } completion:^(BOOL finished) {
        NSLog(@"Animatie geslaagd!");
    }];
}


@end


