//
//  DownloadCell.h
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "Constants.h"
#import "HayateAppDelegate.h"

@interface DownloadCell : UITableViewCell {
    FileModel *fileInfo;
    IBOutlet UIProgressView *progress;
    IBOutlet UILabel *fileName;
    IBOutlet UILabel *fileCurrentSize;
    IBOutlet UILabel *fileSize;
    IBOutlet UILabel *filebaifen;
    IBOutlet UIButton *operateButton;
}

@property(nonatomic,retain)FileModel *fileInfo;
@property(nonatomic,retain)IBOutlet UIProgressView *progress;
@property(nonatomic,retain)IBOutlet UILabel *fileName;
@property(nonatomic,retain)IBOutlet UILabel *fileCurrentSize;
@property(nonatomic,retain)IBOutlet UILabel *fileSize;
@property(nonatomic,retain)IBOutlet UILabel *filebaifen;


@property(nonatomic,retain)IBOutlet UIButton *operateButton;
@property(nonatomic,retain)ASIHTTPRequest *request;//该文件发起的请求

-(IBAction)operateTask:(id)sender;//操作（暂停、继续）正在下载的文件
@end
