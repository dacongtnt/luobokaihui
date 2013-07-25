//
//  DownloadViewController.h
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DownloadCell.h"
#import "FinishedCell.h"
#import "DownloadDelegate.h"
#import "HayateAppDelegate.h"
#import "RootViewController.h"
#import "Constants.h"

@interface DownloadViewController : RootViewController
<UITableViewDataSource,UITabBarDelegate,DownloadDelegate,UITableViewDelegate>{
    IBOutlet UITableView *downloadingTable;
    IBOutlet  UITableView *finishedTable;
    NSMutableArray *downingList;
    NSMutableArray *finishedList;
}

@property(nonatomic,retain)IBOutlet UITableView *downloadingTable;
@property(nonatomic,retain)IBOutlet UITableView *finishedTable;
@property(nonatomic,retain)NSMutableArray *downingList;
@property(nonatomic,retain)NSMutableArray *finishedList;

-(void)showFinished;//查看已下载完成的文件视图
-(void)showDowning;//查看正在下载的文件视图
-(void)startFlipAnimation:(NSInteger)type;//播放旋转动画,0从右向左，1从左向右
-(void)updateCellOnMainThread:(FileModel *)fileInfo;//更新主界面的进度条和信息
@end

