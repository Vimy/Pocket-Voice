//
//  DetailViewController.m
//  Pocket Voice
//
//  Created by Matthias Vermeulen on 1/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "DetailViewController.h"
#import "Pocket_Voice-Swift.h"


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
    __block NSData *audioFile;
    
    WatsonTTSManager *ttsManager = [[WatsonTTSManager alloc]init];
    [ttsManager downloadAudioFromText:self.item.excerpt completionHandler:^(NSData * _Nonnull data)
     {
         audioFile = data;
         NSError *error;
         self.player = [[AVAudioPlayer alloc] initWithData:audioFile error:&error];
         [self.player play];
     }];
}

#pragma mark - Navigation



@end
