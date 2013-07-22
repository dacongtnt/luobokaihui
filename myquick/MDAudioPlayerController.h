//
//  MDAudioPlayerController.h
//  Audio
//
//  Created by 吕 布 on 13-7-20.
//  Copyright (c) 2013年 吕 布. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface MDAudioPlayerController : UIViewController <AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray		*soundFiles;
	NSString			*soundFilesPath;
	NSUInteger			selectedIndex;
	
	AVAudioPlayer		*player;
	
    //渐变效果
	CAGradientLayer		*gradientLayer;
	//播放
	UIButton			*playButton;
	//暂停
    UIButton			*pauseButton;
	//下一曲
    UIButton			*nextButton;
	//上一曲
    UIButton			*previousButton;
    //开关
	UIButton			*toggleButton;
	//循环
    UIButton			*repeatButton;
    //随机
	UIButton			*shuffleButton;
	UILabel				*currentTime;
	UILabel				*duration;
    
    //歌曲信息
	UILabel				*titleLabel;
	UILabel				*artistLabel;
	UILabel				*albumLabel;
    
    
	UILabel				*indexLabel;
	UISlider			*volumeSlider;
    //进度条
	UISlider			*progressSlider;	
	
	UIButton			*artworkView;
	UIImageView			*reflectionView;
	UIView				*containerView;
	UIView				*overlayView;
	
	NSTimer				*updateTimer;
	
	BOOL				interrupted;
	BOOL				repeatAll;
	BOOL				repeatOne;
	BOOL				shuffle;
}

@property (nonatomic, retain) NSMutableArray *soundFiles;
@property (nonatomic, copy) NSString *soundFilesPath;

@property (nonatomic, retain) AVAudioPlayer *player;

@property (nonatomic, retain) CAGradientLayer *gradientLayer;

@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UIButton *pauseButton;
@property (nonatomic, retain) UIButton *nextButton;
@property (nonatomic, retain) UIButton *previousButton;
@property (nonatomic, retain) UIButton *toggleButton;
@property (nonatomic, retain) UIButton *repeatButton;
@property (nonatomic, retain) UIButton *shuffleButton;

@property (nonatomic, retain) UILabel *currentTime;
@property (nonatomic, retain) UILabel *duration;
@property (nonatomic, retain) UILabel *indexLabel;;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UILabel *albumLabel;

@property (nonatomic, retain) UISlider *volumeSlider;
@property (nonatomic, retain) UISlider *progressSlider;

@property (nonatomic, retain) UITableView *songTableView;

@property (nonatomic, retain) UIButton *artworkView;
@property (nonatomic, retain) UIImageView *reflectionView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIView *overlayView;

@property (nonatomic, retain) NSTimer *updateTimer;

@property (nonatomic, assign) BOOL interrupted;
@property (nonatomic, assign) BOOL repeatAll;
@property (nonatomic, assign) BOOL repeatOne;
@property (nonatomic, assign) BOOL shuffle;

- (MDAudioPlayerController *)initWithSoundFiles:(NSMutableArray *)songs atPath:(NSString *)path andSelectedIndex:(int)index;
- (void)dismissAudioPlayer;
- (void)showSongFiles;
- (void)showOverlayView;

- (BOOL)canGoToNextTrack;
- (BOOL)canGoToPreviousTrack;

- (void)play;
- (void)previous;
- (void)next;
- (void)volumeSliderMoved:(UISlider*)sender;
- (void)progressSliderMoved:(UISlider*)sender;

- (void)toggleShuffle;
- (void)toggleRepeat;

@end

