//
//  MDAudioPlayerController.m
//  Audio
//
//  Created by 吕 布 on 13-7-20.
//  Copyright (c) 2013年 吕 布. All rights reserved.
//

#import "MDAudioPlayerController.h"
#import "MDAudioFile.h"
#import "RootViewController.h"

@interface MDAudioPlayerController ()
- (UIImage *)reflectedImage:(UIButton *)fromImage withHeight:(NSUInteger)height;
@end

@implementation MDAudioPlayerController



@synthesize soundFiles;
@synthesize soundFilesPath;

@synthesize player;
@synthesize gradientLayer;

@synthesize playButton;
@synthesize pauseButton;
@synthesize nextButton;
@synthesize previousButton;
@synthesize toggleButton;
@synthesize repeatButton;
@synthesize shuffleButton;

@synthesize currentTime;
@synthesize duration;
@synthesize indexLabel;
@synthesize titleLabel;
@synthesize artistLabel;
@synthesize albumLabel;

@synthesize volumeSlider;
@synthesize progressSlider;


@synthesize artworkView;
@synthesize containerView;
@synthesize overlayView;

@synthesize updateTimer;

@synthesize interrupted;
@synthesize repeatAll;
@synthesize repeatOne;
@synthesize shuffle;


void interruptionListenerCallback (void *userData, UInt32 interruptionState)
{
	MDAudioPlayerController *vc = (MDAudioPlayerController *)userData;
	if (interruptionState == kAudioSessionBeginInterruption)
		vc.interrupted = YES;
	else if (interruptionState == kAudioSessionEndInterruption)
		vc.interrupted = NO;
}

//进度条 时间
-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    //播放时间
	NSString *current = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
    //剩余时间
	NSString *dur = [NSString stringWithFormat:@"-%d:%02d", (int)((int)(p.duration - p.currentTime)) / 60, (int)((int)(p.duration - p.currentTime)) % 60, nil];
	duration.text = dur;
	currentTime.text = current;
	progressSlider.value = p.currentTime;
}

//播放器调用时间显示
- (void)updateCurrentTime
{
	[self updateCurrentTimeForPlayer:self.player];
}


- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
    //歌曲信息
	titleLabel.text = [[soundFiles objectAtIndex:selectedIndex] title];
	artistLabel.text = [[soundFiles objectAtIndex:selectedIndex] artist];
	albumLabel.text = [[soundFiles objectAtIndex:selectedIndex] album];
	
	[self updateCurrentTimeForPlayer:p];
	
	if (updateTimer)
		[updateTimer invalidate];
	
	if (p.playing)
	{
        //移出播放按钮
		[playButton removeFromSuperview];
        
        //加载暂停按钮
		[self.view addSubview:pauseButton];
		updateTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
	}
	else
	{
        //移出暂停按钮
		[pauseButton removeFromSuperview];
        //加载播放按钮
		[self.view addSubview:playButton];
		updateTimer = nil;
	}
	
    //上一曲下一曲
	if (repeatOne || repeatAll || shuffle){
		nextButton.enabled = YES;
        previousButton.enabled=YES;
    }
	else{
		nextButton.enabled = [self canGoToNextTrack];
	previousButton.enabled = [self canGoToPreviousTrack];
    }
}


-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
	duration.text = [NSString stringWithFormat:@"%d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
    //播放的为第几首歌曲
	indexLabel.text = [NSString stringWithFormat:@"%d of %d", (selectedIndex + 1), [soundFiles count]];
    
	progressSlider.maximumValue = p.duration;
}

- (MDAudioPlayerController *)initWithSoundFiles:(NSMutableArray *)songs atPath:(NSString *)path andSelectedIndex:(int)index
{
	if (self = [super init])
	{
		self.soundFiles = songs;
		self.soundFilesPath = path;
		selectedIndex = index;
        
		NSError *error = nil;
        
		self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[(MDAudioFile *)[soundFiles objectAtIndex:selectedIndex] filePath] error:&error];
		[player setNumberOfLoops:0];
		player.delegate = self;
        
        //加入歌曲序号和播放等按钮
		[self updateViewForPlayerInfo:player];
		[self updateViewForPlayerState:player];
		
		if (error)
			NSLog(@"%@", error);
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
	
	updateTimer = nil;
	
	UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	navigationBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	navigationBar.barStyle = UIBarStyleBlackOpaque;
	[self.view addSubview:navigationBar];
	
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
	[navigationBar pushNavigationItem:navItem animated:NO];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(dismissAudioPlayer)];

	navItem.leftBarButtonItem = doneButton;
	[doneButton release];
	doneButton = nil;
    
	[navItem release];
	navItem = nil;
	
	AudioSessionInitialize(NULL, NULL, interruptionListenerCallback, self);
	AudioSessionSetActive(true);
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	
	MDAudioFile *selectedSong = [self.soundFiles objectAtIndex:selectedIndex];
	
    //标题
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 14, 195, 12)];
	//显示文本
    titleLabel.text = [selectedSong title];
	//字体
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
	//背景色
    titleLabel.backgroundColor = [UIColor clearColor];
	//文本颜色
    titleLabel.textColor = [UIColor whiteColor];
	//阴影颜色
    titleLabel.shadowColor = [UIColor blackColor];
    //与原文本偏移量
	titleLabel.shadowOffset = CGSizeMake(0, -1);
	//水平显示位置居中
    titleLabel.textAlignment = UITextAlignmentCenter;
    //折行方式
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[self.view addSubview:titleLabel];
	
	self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 195, 12)];
	artistLabel.text = [selectedSong artist];
	artistLabel.font = [UIFont boldSystemFontOfSize:12];
	artistLabel.backgroundColor = [UIColor clearColor];
	artistLabel.textColor = [UIColor lightGrayColor];
	artistLabel.shadowColor = [UIColor blackColor];
	artistLabel.shadowOffset = CGSizeMake(0, -1);
	artistLabel.textAlignment = UITextAlignmentCenter;
	artistLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[self.view addSubview:artistLabel];
	
	self.albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 27, 195, 12)];
	albumLabel.text = [selectedSong album];
	albumLabel.backgroundColor = [UIColor clearColor];
	albumLabel.font = [UIFont boldSystemFontOfSize:12];
	albumLabel.textColor = [UIColor lightGrayColor];
	albumLabel.shadowColor = [UIColor blackColor];
	albumLabel.shadowOffset = CGSizeMake(0, -1);
	albumLabel.textAlignment = UITextAlignmentCenter;
	albumLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[self.view addSubview:albumLabel];
    
	[navigationBar release];
	navigationBar = nil;
	
    //自适应标签宽度
	duration.adjustsFontSizeToFitWidth = YES;
	currentTime.adjustsFontSizeToFitWidth = YES;
	progressSlider.minimumValue = 0.0;
	
	self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
	[self.view addSubview:containerView];
	
	self.artworkView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    
	[artworkView setImage:[selectedSong coverImage] forState:UIControlStateNormal];
	[artworkView addTarget:self action:@selector(showOverlayView) forControlEvents:UIControlEventTouchUpInside];
	artworkView.showsTouchWhenHighlighted = NO;
	artworkView.adjustsImageWhenHighlighted = NO;
	artworkView.backgroundColor = [UIColor clearColor];
	[containerView addSubview:artworkView];
	
    //渐变效果
	gradientLayer = [[CAGradientLayer alloc] init];
	gradientLayer.frame = CGRectMake(0.0, self.containerView.bounds.size.height - 96, self.containerView.bounds.size.width, 48);
	gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, nil];
	gradientLayer.zPosition = INT_MAX;
    
    //播放按钮
	self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(144, 370, 40, 40)];
	[playButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPlay" ofType:@"png"]] forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	playButton.showsTouchWhenHighlighted = YES;
	[self.view addSubview:playButton];
    
    //暂停按钮
	self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(140, 370, 40, 40)];
	[pauseButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPause" ofType:@"png"]] forState:UIControlStateNormal];
	[pauseButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	pauseButton.showsTouchWhenHighlighted = YES;
	
    //下一曲按钮
	self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 370, 40, 40)];
	[nextButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerNextTrack" ofType:@"png"]]
				forState:UIControlStateNormal];
	[nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
	nextButton.showsTouchWhenHighlighted = YES;
	nextButton.enabled = [self canGoToNextTrack];
	[self.view addSubview:nextButton];
	
    //上一曲按钮
	self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 370, 40, 40)];
	[previousButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPrevTrack" ofType:@"png"]]
                    forState:UIControlStateNormal];
	[previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
	previousButton.showsTouchWhenHighlighted = YES;
	previousButton.enabled = [self canGoToPreviousTrack];
	[self.view addSubview:previousButton];
	
    //音量滑动控件
	self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(25, 420, 270, 9)];
	[volumeSlider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerVolumeKnob" ofType:@"png"]]
                       forState:UIControlStateNormal];
	[volumeSlider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberLeft" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                              forState:UIControlStateNormal];
	[volumeSlider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberRight" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
							  forState:UIControlStateNormal];
	[volumeSlider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventValueChanged];
	
	if ([[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"])
		volumeSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"PlayerVolume"];
	else
		volumeSlider.value = player.volume;
    
	[self.view addSubview:volumeSlider];
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[player play];
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}

- (void)dismissAudioPlayer
{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showOverlayView
{
	if (overlayView == nil)
	{
		self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 76)];
		overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
		overlayView.opaque = NO;
		
        //进度条
		self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(54, 20, 212, 23)];
		[progressSlider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberKnob" ofType:@"png"]]
                             forState:UIControlStateNormal];
		[progressSlider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberLeft" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                                    forState:UIControlStateNormal];
		[progressSlider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberRight" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                                    forState:UIControlStateNormal];
		[progressSlider addTarget:self action:@selector(progressSliderMoved:) forControlEvents:UIControlEventValueChanged];
		progressSlider.maximumValue = player.duration;
		progressSlider.minimumValue = 0.0;
		[overlayView addSubview:progressSlider];
		
        //显示歌曲数目
		self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(128, 2, 64, 21)];
		indexLabel.font = [UIFont boldSystemFontOfSize:12];
		indexLabel.shadowOffset = CGSizeMake(0, -1);
		indexLabel.shadowColor = [UIColor blackColor];
		indexLabel.backgroundColor = [UIColor clearColor];
		indexLabel.textColor = [UIColor whiteColor];
		indexLabel.textAlignment = UITextAlignmentCenter;
		[overlayView addSubview:indexLabel];
		
        //总时间
		self.duration = [[UILabel alloc] initWithFrame:CGRectMake(272, 21, 48, 21)];
		duration.font = [UIFont boldSystemFontOfSize:14];
		duration.shadowOffset = CGSizeMake(0, -1);
		duration.shadowColor = [UIColor blackColor];
		duration.backgroundColor = [UIColor clearColor];
		duration.textColor = [UIColor whiteColor];
		[overlayView addSubview:duration];
		
        //当前时间
		self.currentTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 48, 21)];
		currentTime.font = [UIFont boldSystemFontOfSize:14];
		currentTime.shadowOffset = CGSizeMake(0, -1);
		currentTime.shadowColor = [UIColor blackColor];
		currentTime.backgroundColor = [UIColor clearColor];
		currentTime.textColor = [UIColor whiteColor];
		currentTime.textAlignment = UITextAlignmentRight;
		[overlayView addSubview:currentTime];
		
		duration.adjustsFontSizeToFitWidth = YES;
		currentTime.adjustsFontSizeToFitWidth = YES;
		
        
        //循环按钮
		self.repeatButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 45, 32, 28)];
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOff" ofType:@"png"]]
					  forState:UIControlStateNormal];
		[repeatButton addTarget:self action:@selector(toggleRepeat) forControlEvents:UIControlEventTouchUpInside];
		[overlayView addSubview:repeatButton];
		
        //随机按钮
		self.shuffleButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 45, 32, 28)];
		[shuffleButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerShuffleOff" ofType:@"png"]]
                       forState:UIControlStateNormal];
		[shuffleButton addTarget:self action:@selector(toggleShuffle) forControlEvents:UIControlEventTouchUpInside];
		[overlayView addSubview:shuffleButton];
	}
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
	if ([overlayView superview])
		[overlayView removeFromSuperview];
	else
		[containerView addSubview:overlayView];
	
	[UIView commitAnimations];
}

//随机播放
- (void)toggleShuffle
{
	if (shuffle)
	{
		shuffle = NO;
		[shuffleButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerShuffleOff" ofType:@"png"]] forState:UIControlStateNormal];
	}
	else
	{
		shuffle = YES;
		[shuffleButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerShuffleOn" ofType:@"png"]] forState:UIControlStateNormal];
	}
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}
//循环模式
- (void)toggleRepeat
{
	if (repeatOne)
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOff" ofType:@"png"]]
					  forState:UIControlStateNormal];
		repeatOne = NO;
		repeatAll = NO;
	}
	else if (repeatAll)
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOneOn" ofType:@"png"]]
					  forState:UIControlStateNormal];
		repeatOne = YES;
		repeatAll = NO;
	}
	else
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOn" ofType:@"png"]]
					  forState:UIControlStateNormal];
		repeatOne = NO;
		repeatAll = YES;
	}
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}

- (BOOL)canGoToNextTrack
{
	if (selectedIndex + 1 == [self.soundFiles count])
		return NO;
	else
		return YES;
}

- (BOOL)canGoToPreviousTrack
{
	if (selectedIndex == 0)
		return NO;
	else
		return YES;
}

-(void)play
{
	if (self.player.playing == YES)
	{
		[self.player pause];
	}
	else
	{
		if ([self.player play])
		{
			
		}
		else
		{
			NSLog(@"Could not play %@\n", self.player.url);
		}
	}
	
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}

- (void)previous
{
	NSUInteger newIndex ;
    if (shuffle)
	{
		newIndex = rand() % [soundFiles count];
	}
	else if (repeatOne)
	{
		newIndex = selectedIndex;
	}
	else if (repeatAll)
	{
		if (selectedIndex==0){
			newIndex = [self.soundFiles count]-1;
        }
		else
        {
			newIndex = selectedIndex - 1;
        }
	}
	else
	{
		newIndex = selectedIndex - 1;
	}
	selectedIndex = newIndex;
    
	NSError *error = nil;
	AVAudioPlayer *newAudioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:[(MDAudioFile *)[soundFiles objectAtIndex:selectedIndex] filePath] error:&error];
	
	if (error)
		NSLog(@"%@", error);
	
	[player stop];
	self.player = newAudioPlayer;
	[newAudioPlayer release];
	
	player.delegate = self;
	player.volume = volumeSlider.value;
	[player prepareToPlay];
	[player setNumberOfLoops:0];
	[player play];
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}

- (void)next
{
	NSUInteger newIndex;
	
	if (shuffle)
	{
		newIndex = rand() % [soundFiles count];
	}
	else if (repeatOne)
	{
		newIndex = selectedIndex;
	}
	else if (repeatAll)
	{
		if (selectedIndex + 1 == [self.soundFiles count])
			newIndex = 0;
		else
			newIndex = selectedIndex + 1;
	}
	else
	{
		newIndex = selectedIndex + 1;
	}
	
	selectedIndex = newIndex;
    
	NSError *error = nil;
	AVAudioPlayer *newAudioPlayer =[[AVAudioPlayer alloc] initWithContentsOfURL:[(MDAudioFile *)[soundFiles objectAtIndex:selectedIndex] filePath] error:&error];
    
	if (error)
		NSLog(@"%@", error);
	
	[player stop];
	self.player = newAudioPlayer;
	[newAudioPlayer release];
	
	player.delegate = self;
	player.volume = volumeSlider.value;
	[player prepareToPlay];
	[player setNumberOfLoops:0];
	[player play];
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}

//声音调节
- (void)volumeSliderMoved:(UISlider *)sender
{
	player.volume = [sender value];
	[[NSUserDefaults standardUserDefaults] setFloat:[sender value] forKey:@"PlayerVolume"];
}

//滑动快进
- (void)progressSliderMoved:(UISlider *)sender
{
	player.currentTime = sender.value;
	[self updateCurrentTimeForPlayer:player];
}


#pragma mark -
#pragma mark AVAudioPlayer delegate

//播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
	if (flag == NO)
		NSLog(@"Playback finished unsuccessfully");
	
	if ([self canGoToNextTrack])
        [self next];
	else if (interrupted)
		[self.player play];
	else
		[self.player stop];
    
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}
//解码错误执行
- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error);
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Decode Error"
														message:[NSString stringWithFormat:@"Unable to decode audio file with error: %@", [error localizedDescription]]
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}
//处理中断代码
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	// perform any interruption handling here
	printf("(apbi) Interruption Detected\n");
	[[NSUserDefaults standardUserDefaults] setFloat:[self.player currentTime] forKey:@"Interruption"];
}
//处理中段结束代码
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	// resume playback at the end of the interruption
	printf("(apei) Interruption ended\n");
	[self.player play];
	
	// remove the interruption key. it won't be needed
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Interruption"];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[player release];
	player = nil;
}
- (void)dealloc
{
	[soundFiles release], soundFiles = nil;
	[soundFilesPath release], soundFiles = nil;
	[player release], player = nil;
	[gradientLayer release], gradientLayer = nil;
	[playButton release], playButton = nil;
	[pauseButton release], pauseButton = nil;
	[nextButton release], nextButton = nil;
	[previousButton release], previousButton = nil;
	[toggleButton release], toggleButton = nil;
	[repeatButton release], repeatButton = nil;
	[shuffleButton release], shuffleButton = nil;
	[currentTime release], currentTime = nil;
	[duration release], duration = nil;
	[indexLabel release], indexLabel = nil;
	[titleLabel release], titleLabel = nil;
	[artistLabel release], artistLabel = nil;
	[albumLabel release], albumLabel = nil;
	[volumeSlider release], volumeSlider = nil;
	[progressSlider release], progressSlider = nil;
	[artworkView release], artworkView = nil;
	[containerView release], containerView = nil;
	[overlayView release], overlayView = nil;
	[updateTimer invalidate], updateTimer = nil;
	[super dealloc];
}
@end