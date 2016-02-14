//
//  AudioControlsView.h
//  AudioControls
//
//  Created by Matthias Vermeulen on 14/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioControlsView : UIView <AVAudioPlayerDelegate>

@property (weak, nonatomic) NSURL *fileURL;
@property (weak, nonatomic) IBOutlet UILabel *elapsedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;


@property (nonatomic, strong) AVAudioPlayer* player;
@property (nonatomic, strong) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)stop:(id)sender;

- (IBAction)currentTimeSliderValueChanged:(id)sender;
- (IBAction)currentTimeSliderTouchUpInside:(id)sender;

//- (instancetype)initWithAudioFile:(NSURL *)url;
@end
