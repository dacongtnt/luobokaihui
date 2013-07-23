//
//  CViewController.h
//  AA
//
//  Created by 张 伟 on 13-7-19.
//  Copyright (c) 2013年 关 公. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "RootViewController.h"

@interface AViewController : RootViewController<AVAudioRecorderDelegate,UIAlertViewDelegate>
{
    UILabel *label;
    UILabel *labelZero;
    UILabel *labelOne;
    UIActivityIndicatorView *aIndicator;
    UIButton *startButton;
    UIButton *playButton;
    NSError *error;
    BOOL flag;
    NSURL *recordedTmpFile;
    AVAudioRecorder *recorder;
    UIProgressView *_progressView;
    AVAudioPlayer * avPlayer;
    NSTimer *timer;
    NSTimer *tProcess;
    UISlider *slider;
    NSInteger a,b,c,d,e;
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
@end
