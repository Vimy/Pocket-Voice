//
//  AudioControlsView.m
//  AudioControls
//
//  Created by Matthias Vermeulen on 14/02/16.
//  Copyright © 2016 Noizy. All rights reserved.
//

#import "AudioControlsView.h"


@implementation AudioControlsView




- (void)setFileURL:(NSURL *)fileURL
{
    _fileURL = fileURL;
 
   
    //audio controls
    //    self.playSlider.minimumTrackTintColor = [UIColor blackColor];
    //    self.playSlider.maximumTrackTintColor = [UIColor blackColor];
    //    UIImage *image = [[UIImage imageNamed:@"slider-thumb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //    [self.playSlider setThumbImage:image forState:UIControlStateNormal];
    
    // Sound item
    
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.fileURL error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
    
}



- (IBAction)play:(id)sender {
   
    
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
 
}

- (IBAction)pause:(id)sender {
 
    [self.player pause];
    [self stopTimer];
    [self updateDisplay];
}

- (IBAction)stop:(id)sender {

    [self.player stop];
    [self stopTimer];
    self.player.currentTime = 0;
    [self.player prepareToPlay];
    [self updateDisplay];
}

- (IBAction)currentTimeSliderValueChanged:(id)sender
{
    if(self.timer)
        [self stopTimer];
    [self updateDisplay];
    [self updateSliderLabels];
}

- (IBAction)currentTimeSliderTouchUpInside:(id)sender
{
    [self.player stop];
    self.player.currentTime = self.currentTimeSlider.value;
    [self.player prepareToPlay];
    [self play:self];
}

#pragma mark - Display Update
- (void)updateDisplay
{
    NSTimeInterval currentTime = self.player.currentTime;
    
    self.currentTimeSlider.value = currentTime;
    [self updateSliderLabels];
    
    self.remainingTimeLabel.text = [self convertTime:(int)self.player.duration];
    self.currentTimeSlider.minimumValue = 0.0f;
    self.currentTimeSlider.maximumValue = self.player.duration;

}

- (void)updateSliderLabels
{
    
    NSString* currentTimeString = [self convertTime:(int)self.currentTimeSlider.value];
    
    self.elapsedTimeLabel.text =  currentTimeString;
    self.remainingTimeLabel.text = [self convertTime:(int)self.player.duration];
}

#pragma mark - Timer
- (void)timerFired:(NSTimer*)timer
{
    [self updateDisplay];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
    [self updateDisplay];
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
    [self updateDisplay];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%s error=%@", __PRETTY_FUNCTION__, error);
    [self stopTimer];
    [self updateDisplay];
}


@end
