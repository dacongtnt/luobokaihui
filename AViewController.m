//
//  CViewController.m
//  AA
//
//  Created by 张 伟 on 13-7-19.
//  Copyright (c) 2013年 关 公. All rights reserved.
//

#import "AViewController.h"
#import "HsTable.h"

@interface AViewController ()

@end

@implementation AViewController

@synthesize str;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        a=0;
        b=0;
        c=0;
        d=1;
        e=0;
        flag=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];
        
    dateformatter=[[NSDateFormatter alloc]init];
    dateformatter.dateFormat=@"YYYY-MM-dd hh:mm:ss";
    
    UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320, 360)];
    view.backgroundColor=[UIColor clearColor];
    UIImage *img=[UIImage imageNamed:@"001.png"];
    view.image=img;
    [img release];
    [self.view addSubview:view];
    [view release];
    
    UIImageView *bView=[[UIImageView alloc]initWithFrame:CGRectMake(70, 365,180, 75)];
    bView.backgroundColor=[UIColor clearColor];
    UIImage *bImg=[UIImage imageNamed:@"006.png"];
    bView.image=bImg;
    [bImg release];
    [self.view addSubview:bView];
    [bView release];
    
    startButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton setBackgroundImage:[UIImage imageNamed:@"002.png"] forState:UIControlStateNormal];
    [startButton setFrame:CGRectMake(3 , 370, 60, 60)];
    [startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    playButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [playButton setBackgroundImage:[UIImage imageNamed:@"004.png"] forState:UIControlStateNormal];
    [playButton setFrame:CGRectMake(257 , 370, 60, 60)];
    [playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)startButtonPressed
{
    if (!flag) {
        flag = !flag;
        [startButton setBackgroundImage:[UIImage imageNamed:@"002.png"] forState:UIControlStateNormal];
        self.navigationItem.title=[NSString stringWithFormat:@"录音 %d%d:%d%d",a,b,c,d];
        
        NSFileManager *fm=[NSFileManager defaultManager];
        NSString *arr=[[fm subpathsAtPath:NSTemporaryDirectory()]lastObject];
        [recorder stop];
        [tProcess invalidate];
    }else{
        a=0;b=0;c=0;d=0;
        flag = !flag;
        self.str=[dateformatter stringFromDate:[NSDate date]];
        
        tProcess=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeProcess) userInfo:nil repeats:YES];
        [startButton setBackgroundImage:[UIImage imageNamed:@"005.png"] forState:UIControlStateNormal];
        NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:slider.value] forKey:AVSampleRateKey];
        recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
        NSLog(@"%@",recordedTmpFile);
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
        [recorder setDelegate:self];
        [recorder prepareToRecord];
        [recorder record];
    }
}

- (void)playButtonPressed
{
    self.navigationItem.title=@"录音";
    HsTable *record=[[HsTable alloc]init];
    [self.navigationController pushViewController:record animated:YES];
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
    self.navigationItem.title=[NSString stringWithFormat:@"正在录音..%d%d:%d%d",a,b,c,d];
}

- (void)viewDidUnload {
    NSFileManager * fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:[recordedTmpFile path] error:&error];
    [recorder dealloc];
    recorder = nil;
    recordedTmpFile = nil;
}
@end
