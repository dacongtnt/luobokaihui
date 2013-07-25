//
//  HsTable.h
//  myquick
//
//  Created by 张 伟 on 13-7-25.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AViewController.h"

@interface HsTable :UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView0;
    NSArray *files;
    UIProgressView *_progressView;
    AVAudioPlayer * avPlayer;
    NSError *error;
    NSTimer *timer;
    NSURL *recordedTmpFile;
    UIView *view;
    UILabel *currentTime;
    UILabel *allTime;
}

@end
