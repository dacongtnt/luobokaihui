//
//  DownloadCell.m
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import "DownloadCell.h"


@implementation DownloadCell
@synthesize fileInfo;
@synthesize progress;
@synthesize fileName;
@synthesize fileCurrentSize;
@synthesize fileSize;
@synthesize operateButton;
@synthesize request;

- (void)dealloc
{
    [request release];
    [operateButton release];
    [fileName release];
    [fileCurrentSize release];
    [fileSize release];
    [progress release];
    [fileInfo release];
    [super dealloc];
}

-(IBAction)operateTask:(id)sender
{
    HayateAppDelegate *appDelegate=APPDELEGETE;
    UIButton *btnOperate=(UIButton *)sender;
    FileModel *downFile=((DownloadCell *)[[[btnOperate superview] superview]superview]).fileInfo;
    if(downFile.isDownloading)//文件正在下载，点击之后暂停下载
    {
        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_stop.png"] forState:UIControlStateNormal];
        downFile.isDownloading=NO;
        [request cancel];
        [request release];
        request=nil;
    }
    else
    {
        [operateButton setBackgroundImage:[UIImage imageNamed:@"downloading_go.png"] forState:UIControlStateNormal];
        downFile.isDownloading=YES;
        [appDelegate beginRequest:downFile isBeginDown:YES];
    }
    //暂停意味着这个Cell里的ASIHttprequest已被释放，要及时更新table的数据，使最新的ASIHttprequest控制Cell
    UITableView *tableView=(UITableView *)[[[[btnOperate superview] superview] superview] superview];
    [tableView reloadData];
}
@end
