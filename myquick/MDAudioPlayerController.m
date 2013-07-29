//
//  AudioPlayer.m
//  MobileTheatre
//
//  Created by Matt Donnelly on 27/03/2010.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MDAudioPlayerController.h"
#import "MDAudioFile.h"
#import "MDAudioPlayerTableViewCell.h"

@interface MDAudioPlayerController ()
- (UIImage *)reflectedImage:(UIButton *)fromImage withHeight:(NSUInteger)height;
@end

@implementation MDAudioPlayerController

static const CGFloat kDefaultReflectionFraction = 0.65;
static const CGFloat kDefaultReflectionOpacity = 0.40;

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

@synthesize songTableView;

@synthesize artworkView;
@synthesize reflectionView;
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

//进度条 剩余时间
-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
	NSString *current = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
	NSString *dur = [NSString stringWithFormat:@"-%d:%02d", (int)((int)(p.duration - p.currentTime)) / 60, (int)((int)(p.duration - p.currentTime)) % 60, nil];
	duration.text = dur;
	currentTime.text = current;
	progressSlider.value = p.currentTime;
}

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
	
    //后台播放
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
	UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    UIBackgroundTaskIdentifier oldTakId = 0;
    if(newTaskId != UIBackgroundTaskInvalid && oldTakId != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:oldTakId];
    }
    oldTakId = newTaskId;
    
	
	updateTimer = nil;
    
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
	self.toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	[toggleButton setImage:[UIImage imageNamed:@"AudioPlayerAlbumInfo.png"] forState:UIControlStateNormal];
	[toggleButton addTarget:self action:@selector(showSongFiles) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *songsListBarButton = [[UIBarButtonItem alloc] initWithCustomView:toggleButton];
	
	self.navigationItem.rightBarButtonItem = songsListBarButton;
	[songsListBarButton release];
	songsListBarButton = nil;
	
	[navItem release];
	navItem = nil;
	
	AudioSessionInitialize(NULL, NULL, interruptionListenerCallback, self);
	AudioSessionSetActive(true);
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
	
	MDAudioFile *selectedSong = [self.soundFiles objectAtIndex:selectedIndex];
	
	//标题
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-55, -4, 120, 12)];
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
    
	self.artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(-55, -17, 120, 12)];
	artistLabel.text = [selectedSong artist];
	artistLabel.font = [UIFont boldSystemFontOfSize:12];
	artistLabel.backgroundColor = [UIColor clearColor];
	artistLabel.textColor = [UIColor lightGrayColor];
	artistLabel.shadowColor = [UIColor blackColor];
	artistLabel.shadowOffset = CGSizeMake(0, -1);
	artistLabel.textAlignment = UITextAlignmentCenter;
	artistLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[self.view addSubview:artistLabel];
	
	self.albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(-55, 7, 120, 12)];
	albumLabel.text = [selectedSong album];
	albumLabel.backgroundColor = [UIColor clearColor];
	albumLabel.font = [UIFont boldSystemFontOfSize:12];
	albumLabel.textColor = [UIColor lightGrayColor];
	albumLabel.shadowColor = [UIColor blackColor];
	albumLabel.shadowOffset = CGSizeMake(0, -1);
	albumLabel.textAlignment = UITextAlignmentCenter;
	albumLabel.lineBreakMode = UILineBreakModeTailTruncation;
	[self.view addSubview:albumLabel];
    
    UIView *titleLabels =[[UIView alloc] init];
    [titleLabels addSubview:titleLabel];
    [titleLabels addSubview:artistLabel];
    [titleLabels addSubview:albumLabel];
    self.navigationItem.titleView=titleLabels;
    
    
	
    //自适应标签宽度
	duration.adjustsFontSizeToFitWidth = YES;
	currentTime.adjustsFontSizeToFitWidth = YES;
	progressSlider.minimumValue = 0.0;
	
	self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
	[self.view addSubview:containerView];
	
	self.artworkView = [[UIButton alloc] initWithFrame:CGRectMake(0, -60, 320, 380)];
	[artworkView setImage:[selectedSong coverImage] forState:UIControlStateNormal];
	[artworkView addTarget:self action:@selector(showOverlayView) forControlEvents:UIControlEventTouchUpInside];
    
	artworkView.showsTouchWhenHighlighted = NO;
	artworkView.adjustsImageWhenHighlighted = NO;
	artworkView.backgroundColor = [UIColor clearColor];
	[containerView addSubview:artworkView];
	
	self.reflectionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 320, 320, 96)];
	reflectionView.image = [self reflectedImage:artworkView withHeight:artworkView.bounds.size.height * kDefaultReflectionFraction];
	reflectionView.alpha = kDefaultReflectionFraction;
	[self.containerView addSubview:reflectionView];
	
	self.songTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 368)];
	self.songTableView.delegate = self;
	self.songTableView.dataSource = self;
	self.songTableView.separatorColor = [UIColor colorWithRed:0.986 green:0.933 blue:0.994 alpha:0.10];
	self.songTableView.backgroundColor = [UIColor clearColor];
	self.songTableView.contentInset = UIEdgeInsetsMake(0, 0, 37, 0);
	self.songTableView.showsVerticalScrollIndicator = NO;
    
	
    //自适应标签宽度
	gradientLayer = [[CAGradientLayer alloc] init];
	gradientLayer.frame = CGRectMake(0.0, self.containerView.bounds.size.height - 96, self.containerView.bounds.size.width, 48);
	gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor, (id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, nil];
	gradientLayer.zPosition = INT_MAX;
	
	/*! HACKY WAY OF REMOVING EXTRA SEPERATORS */
	
	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	v.backgroundColor = [UIColor clearColor];
	[self.songTableView setTableFooterView:v];
	[v release];
	v = nil;
    
	UIImageView *buttonBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 + 300, self.view.bounds.size.width, 96)];
	buttonBackground.image = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerBarBackground" ofType:@"png"]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[self.view addSubview:buttonBackground];
	[buttonBackground release];
	buttonBackground  = nil;
    
	self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(144, 350, 40, 40)];
	[playButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPlay" ofType:@"png"]] forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	playButton.showsTouchWhenHighlighted = YES;
	[self.view addSubview:playButton];
    
	self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(140, 350, 40, 40)];
	[pauseButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPause" ofType:@"png"]] forState:UIControlStateNormal];
	[pauseButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
	pauseButton.showsTouchWhenHighlighted = YES;
	
	self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 350, 40, 40)];
	[nextButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerNextTrack" ofType:@"png"]]
				forState:UIControlStateNormal];
	[nextButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
	nextButton.showsTouchWhenHighlighted = YES;
	nextButton.enabled = [self canGoToNextTrack];
	[self.view addSubview:nextButton];
	
	self.previousButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 350, 40, 40)];
	[previousButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerPrevTrack" ofType:@"png"]]
                    forState:UIControlStateNormal];
	[previousButton addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
	previousButton.showsTouchWhenHighlighted = YES;
	previousButton.enabled = [self canGoToPreviousTrack];
	[self.view addSubview:previousButton];
	
	self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(25, 400, 270, 9)];
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
    //	[player play];
	
	[self updateViewForPlayerInfo:player];
	[self updateViewForPlayerState:player];
}

- (void)dismissAudioPlayer
{
	CGContextRef *context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"curl" context:context];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationTransition:UIViewContentModeCenter forView:self.view cache:YES];
    
    [UIView commitAnimations];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSongFiles
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	
	[UIView setAnimationTransition:([self.songTableView superview] ?
									UIViewContentModeTopLeft : UIViewContentModeTopRight)
						   forView:self.toggleButton cache:YES];
	if ([songTableView superview])
		[self.toggleButton setImage:[UIImage imageNamed:@"AudioPlayerAlbumInfo.png"] forState:UIControlStateNormal];
	else
		[self.toggleButton setImage:self.artworkView.imageView.image forState:UIControlStateNormal];
	
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	
	[UIView setAnimationTransition:([self.songTableView superview] ?
									UIViewContentModeTopLeft : UIViewContentModeTopRight)
						   forView:self.containerView cache:YES];
	if ([songTableView superview])
	{
		[self.songTableView removeFromSuperview];
		[self.artworkView setImage:[[soundFiles objectAtIndex:selectedIndex] coverImage] forState:UIControlStateNormal];
		[self.containerView addSubview:reflectionView];
		
		[gradientLayer removeFromSuperlayer];
	}
	else
	{
		[self.artworkView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerTableBackground" ofType:@"png"]] forState:UIControlStateNormal];
		[self.reflectionView removeFromSuperview];
		[self.overlayView removeFromSuperview];
		[self.containerView addSubview:songTableView];
		
		[[self.containerView layer] insertSublayer:gradientLayer atIndex:0];
	}
	
	[UIView commitAnimations];
}

- (void)showOverlayView
{
	if (overlayView == nil)
	{
		self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -30, self.view.bounds.size.width, 76)];
		overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
		overlayView.opaque = NO;
		
        //进度条
		self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(54, 20, 212, 23)];
		[progressSlider setThumbImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberKnob" ofType:@"png"]]
                             forState:UIControlStateNormal];
		[progressSlider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberLeft" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
                                    forState:UIControlStateNormal];
        //		[progressSlider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerScrubberRight" ofType:@"png"]] stretchableImageWithLeftCapWidth:5 topCapHeight:3]
        //                                    forState:UIControlStateNormal];
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
        self.player.numberOfLoops=-1;
	}
	else if (repeatAll)
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOneOn" ofType:@"png"]]
					  forState:UIControlStateNormal];
        
        self.player.numberOfLoops=-1;
		repeatOne = YES;
		repeatAll = NO;
        
	}
	else
	{
		[repeatButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AudioPlayerRepeatOn" ofType:@"png"]]
					  forState:UIControlStateNormal];
		repeatOne = NO;
		repeatAll = YES;
        self.player.numberOfLoops=0;
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
	
	if ([self canGoToNextTrack]|repeatAll)
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
    [player stop];
	[player release];
	player = nil;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return [soundFiles count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    MDAudioPlayerTableViewCell *cell = (MDAudioPlayerTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[MDAudioPlayerTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.title = [[soundFiles objectAtIndex:indexPath.row] title];
	cell.number = [NSString stringWithFormat:@"%d.", (indexPath.row + 1)];
	cell.duration = [[soundFiles objectAtIndex:indexPath.row] durationInMinutes];
    
	cell.isEven = indexPath.row % 2;
	
	if (selectedIndex == indexPath.row)
		cell.isSelectedIndex = YES;
	else
		cell.isSelectedIndex = NO;
	
	return cell;
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	selectedIndex = indexPath.row;
	
	for (MDAudioPlayerTableViewCell *cell in [aTableView visibleCells])
	{
		cell.isSelectedIndex = NO;
	}
	
	MDAudioPlayerTableViewCell *cell = (MDAudioPlayerTableViewCell *)[aTableView cellForRowAtIndexPath:indexPath];
	cell.isSelectedIndex = YES;
	
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

- (BOOL)tableView:(UITableView *)table canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}


#pragma mark - Image Reflection

CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
	CGImageRef theCGImage = NULL;
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
															   8, 0, colorSpace, kCGImageAlphaNone);
    
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
	
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
														0, colorSpace,
														// this will give us an optimal BGRA format for the device:
														(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
	
    return bitmapContext;
}

- (UIImage *)reflectedImage:(UIButton *)fromImage withHeight:(NSUInteger)height
{
    if (height == 0)
		return nil;
    
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
	
	CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
	CGImageRelease(gradientMaskImage);
    
	CGContextTranslateCTM(mainViewContentContext, 0.0, height);
	CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
	
	CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.imageView.image.CGImage);
	
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	CGImageRelease(reflectionImage);
	
	return theImage;
}

- (void)viewDidUnload
{
	self.reflectionView = nil;
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
	[songTableView release], songTableView = nil;
	[artworkView release], artworkView = nil;
	[reflectionView release], reflectionView = nil;
	[containerView release], containerView = nil;
	[overlayView release], overlayView = nil;
	[updateTimer invalidate], updateTimer = nil;
	[super dealloc];
}


@end
