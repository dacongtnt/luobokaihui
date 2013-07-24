//
//  MusicCell.m
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import "MusicCell.h"
#import "MBAlertView.h"

@implementation MusicCell
@synthesize imgview;
@synthesize musicName;
@synthesize musicSize;
@synthesize musicDown;
@synthesize fileInfo;
@synthesize musiclabel;

- (void)dealloc
{
    [fileInfo release];
    [musicDown release];
    [musicSize release];
    [musicName release];
    [super dealloc];
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgview=[[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)]autorelease];
        [self.contentView addSubview:self.imgview];
        
        self.musicName=[[[UILabel alloc]initWithFrame:CGRectMake(70, 50,140 , 30)]autorelease];
        [self.contentView addSubview:self.musicName];
        
        self.musiclabel=[[[UILabel alloc]initWithFrame:CGRectMake(70, 50,70 , 30)]autorelease];
        [self.contentView addSubview:self.musiclabel];
        
        self.musicSize=[[[UILabel alloc]initWithFrame:CGRectMake(140, 10,70 , 30)]autorelease];
        [self.contentView addSubview:self.musicSize];
        
        self.musicDown=[[[UIButton alloc]initWithFrame:CGRectMake(220, 10,100 , 30)]autorelease];
        [self.contentView addSubview:self.musicDown];
    }
    return self;
}
-(void)downMusic:(id)sender
{
    FileModel *selectFileInfo=self.fileInfo;
    //因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
    NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:selectFileInfo.fileName];
    NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:selectFileInfo.fileName]stringByAppendingString:@".temp"];
    if([CommonHelper isExistFile:targetPath])//已经下载过一次该音乐
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！是否重新下载该文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    //存在于临时文件夹里
    if([CommonHelper isExistFile:tempPath])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经添加到您的下载列表中了！是否重新下载该文件？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        [alert release];
        return;
    }
    selectFileInfo.isDownloading=YES;
    //若不存在文件和临时文件，则是新的下载
    HayateAppDelegate *appDelegate=APPDELEGETE;
    [appDelegate beginRequest:selectFileInfo isBeginDown:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jump" object:nil];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)//确定按钮
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        HayateAppDelegate *appDelegate=APPDELEGETE;
        NSString *targetPath=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:self.fileInfo.fileName];
        NSString *tempPath=[[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:self.fileInfo.fileName]stringByAppendingString:@".temp"];
        if([CommonHelper isExistFile:targetPath])//已经下载过一次该音乐
        {
            [fileManager removeItemAtPath:targetPath error:&error];
            if(!error)
            {
                NSLog(@"删除文件出错:%@",error);
            }
            for(FileModel *file in appDelegate.finishedlist)
            {
                if([file.fileName isEqualToString:self.fileInfo.fileName])
                {
                    [appDelegate.finishedlist removeObject:file];
                    break;
                }
            }
        }
        //存在于临时文件夹里
        if([CommonHelper isExistFile:tempPath])
        {
            [fileManager removeItemAtPath:tempPath error:&error];
            if(!error)
            {
                NSLog(@"删除临时文件出错:%@",error);
            }
        }
        
        for(ASIHTTPRequest *request in appDelegate.downinglist)
        {
            FileModel *fileModel=[request.userInfo objectForKey:@"File"];
            if([fileModel.fileName isEqualToString:self.fileInfo.fileName])
            {
                [appDelegate.downinglist removeObject:request];
                break;
            }
        }
        self.fileInfo.isDownloading=YES;
        self.fileInfo.fileReceivedSize=[CommonHelper getFileSizeString:@"0"];
        [appDelegate beginRequest:self.fileInfo isBeginDown:YES];
    }
}

@end

