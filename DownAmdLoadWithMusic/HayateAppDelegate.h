//
//  HayateAppDelegate.h
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "CommonHelper.h"
#import "DownloadDelegate.h"
#import "FileModel.h"
#import "DownloadCell.h"
#import <AVFoundation/AVAudioPlayer.h>

@class HayateViewController;

@interface HayateAppDelegate : NSObject <UIApplicationDelegate
,ASIHTTPRequestDelegate,ASIProgressDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabController;

@property(nonatomic,retain)NSMutableArray *finishedlist;//已下载完成的文件列表（文件对象）

@property(nonatomic,retain)NSMutableArray *downinglist;//正在下载的文件列表(ASIHttpRequest对象)

@property(nonatomic,retain)id<DownloadDelegate> downloadDelegate;

@property(nonatomic,retain)AVAudioPlayer *buttonSound;//按钮声音

@property(nonatomic,retain)AVAudioPlayer *downloadCompleteSound;//下载完成的声音

@property(nonatomic)BOOL isFistLoadSound;//是否第一次加载声音，静音


-(void)loadTempfiles;//将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
-(void)loadFinishedfiles;//将本地已经下载完成的文件加载到已下载列表里
-(void)playButtonSound;//播放按钮按下时的声音
-(void)playDownloadSound;//播放下载完成时的声音

//1.点击百度或者土豆的下载，进行一次新的队列请求
//2.是否接着开始下载
-(void)beginRequest:(FileModel *)fileInfo isBeginDown:(BOOL)isBeginDown;
@end
