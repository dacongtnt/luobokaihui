//
//  CViewController.m
//  AA
//
//  Created by 张 伟 on 13-7-19.
//  Copyright (c) 2013年 关 公. All rights reserved.
//

#import "AViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        a=0;
        b=0;
        c=0;
        d=0;
        e=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"music.jpg"]]];
    flag=YES;
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(100, 40, 60, 40)];
    label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:label];
    [label release];
    
    labelOne=[[UILabel alloc]initWithFrame:CGRectMake(30, 40, 80, 40)];
    labelOne.text=@"音量";
    labelOne.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelOne];
    [labelOne release];
    
    slider=[[UISlider alloc]initWithFrame:CGRectMake(30, 80, 250, 30)];
    slider.minimumValue=0.0;
    slider.maximumValue=6.0;
    slider.value=3.0;
    int i=(int)slider.value;
    label.text=[NSString stringWithFormat:@"%d",i];
    slider.backgroundColor=[UIColor clearColor];
    [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    [slider release];

    aIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [aIndicator setFrame:CGRectMake(170, 140, 40 , 40)];
    [self.view addSubview:aIndicator];
    [aIndicator release];
    
    labelZero=[[UILabel alloc]initWithFrame:CGRectMake(50, 140, 150, 40)];
    labelZero.backgroundColor=[UIColor clearColor];
    [self.view addSubview:labelZero];
    [labelZero release];
    
    startButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton setFrame:CGRectMake(60, 220, 200, 40)];
    [startButton setTitle:@"开始录音" forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    playButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playButton setFrame:CGRectMake(60, 300, 200, 40)];
    [playButton setTitle:@"播放录音" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    playButton.enabled=NO;
    [self.view addSubview:playButton];
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"完成的录音" style:UIBarButtonItemStylePlain target:self action:@selector(rightButton)];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)sliderChanged:(UISlider *)sender
{
    int i=(int)sender.value;
    NSString *str=[NSString stringWithFormat:@"%d",i];
    label.text=str;
}

- (void)startButtonPressed
{
    if (!flag) {
        flag = !flag;
        [aIndicator stopAnimating];
        [startButton setTitle:@"开始录音" forState:UIControlStateNormal];
        playButton.enabled = flag;
        labelZero.text=@" ";
        [recorder stop];
        [tProcess invalidate];
    }else{
        a=0;b=0;c=0;d=0;
        flag = !flag;
        [aIndicator startAnimating];
        [startButton setTitle:@"暂停录音" forState:UIControlStateNormal];
        playButton.enabled = flag;
        tProcess=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeProcess) userInfo:nil repeats:YES];
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:slider.value] forKey:AVSampleRateKey];
        recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
        NSLog(@"Using File called: %@",recordedTmpFile);
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
    }
}

- (void)playButtonPressed
{
    if (flag) {
        e=0;
        flag = !flag;
        startButton.enabled = flag;
        [playButton setTitle:@"停止播放" forState:UIControlStateNormal];
        labelZero.text=@"播放中...";
        avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
        [avPlayer prepareToPlay];
        [avPlayer play];
        
        _progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(1, 1, 318, 8)];
        [self.view addSubview:_progressView];
        [_progressView release];
        _progressView.progress=0.0f;
        
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(refreshUR:)
                                       userInfo:nil
                                        repeats:YES];
    }else{
        flag = !flag;
        startButton.enabled = flag;
        [playButton setTitle:@"播放录音" forState:UIControlStateNormal];
        [timer invalidate];
        [_progressView removeFromSuperview];
        labelZero.text=@"";
    }
}

- (void)timeProcess
{
    d++;
    if (d==10) {
        d=0;
        c++;
        if (c==6) {
            c=0;
            b++;
            if (b==10) {
                b=0;
                a++;
            }
        }
    }
    labelZero.text=[NSString stringWithFormat:@"正在录音..%d%d:%d%d",a,b,c,d];
}

-(void)refreshUR:(NSTimer *)aTimer{
    e++;
    float p=avPlayer.currentTime/avPlayer.duration;
    _progressView.progress=p;
    if (e==d+c*10+b*60+a*10*60) {
        _progressView.hidden=YES;
        [avPlayer stop];
        [timer invalidate];
        [self playButtonPressed];
    }
}

- (void)liftButton
{
    if (!flag) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"warning" message:@"是否取消录音" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [alert show];
        [alert release];
    }else{
        NSLog(@"left");
    }
}

- (void)rightButton
{
    NSLog(@"sadfsa");
}

- (void)viewDidUnload {
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[recordedTmpFile path] error:&error];
    [recorder dealloc];
    recorder = nil;
    recordedTmpFile = nil;
}
@end
