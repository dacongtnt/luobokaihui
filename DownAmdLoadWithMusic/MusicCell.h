//
//  MusicCell.h
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "HayateAppDelegate.h"
#import "Constants.h"
#import "ASIHTTPRequest.h"
#import "CommonHelper.h"

@interface MusicCell : UITableViewCell <UIAlertViewDelegate,UIAlertViewDelegate>{
    UILabel *musicName;
    UILabel *musicSize;
    UIButton *musicDown;
    FileModel *fileInfo;
}
@property(nonatomic,retain)UIImageView *imgview;
@property(nonatomic,retain)UILabel *musicName;
@property(nonatomic,retain)UILabel *musicSize;
@property(nonatomic,retain)UILabel *musiclabel;
@property(nonatomic,retain)UIButton *musicDown;
@property(nonatomic,retain)FileModel *fileInfo;

-(IBAction)downMusic:(id)sender;//点击下载开始下载
@end
