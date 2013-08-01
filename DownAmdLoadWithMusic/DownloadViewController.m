//
//  DownloadViewController.m
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//
#import "DownloadViewController.h"
#import "Memo.h"

@implementation DownloadViewController

@synthesize downloadingTable;
@synthesize finishedTable;
@synthesize downingList;
@synthesize finishedList;


- (void)dealloc
{
    [downingList release];
    [finishedList release];
    [downloadingTable release];
    [finishedTable release];
    [super dealloc];
}

-(void)showFinished
{
    [self startFlipAnimation:0];
    self.title=@"已下载的音乐";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"正在下载的文件" style:UIBarButtonItemStylePlain target:self action:@selector(showDowning)]autorelease];
}

-(void)showDowning
{
    [self startFlipAnimation:1];
    self.title=@"正在下载的音乐";
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"已下载的文件" style:UIBarButtonItemStylePlain target:self action:@selector(showFinished)]autorelease];
}


-(void)startFlipAnimation:(NSInteger)type
{
    [APPDELEGETE playButtonSound];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0f];
    UIView *lastView=[self.view viewWithTag:103];
    
    if(type==0)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:lastView cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lastView cache:YES];
    }
    
    UITableView *frontTableView=(UITableView *)[lastView viewWithTag:101];
    UITableView *backTableView=(UITableView *)[lastView viewWithTag:102];
    NSInteger frontIndex=[lastView.subviews indexOfObject:frontTableView];
    NSInteger backIndex=[lastView.subviews indexOfObject:backTableView];
    [lastView exchangeSubviewAtIndex:frontIndex withSubviewAtIndex:backIndex];
    [UIView commitAnimations];
}

-(void)leaveEdit
{
    [APPDELEGETE playButtonSound];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(enterEdit)]autorelease];
    [self.downloadingTable setEditing:NO animated:YES];
    [self.finishedTable setEditing:NO animated:YES];
}

-(void)enterEdit
{
    [APPDELEGETE playButtonSound];
    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(leaveEdit)]autorelease];
    [self.downloadingTable setEditing:YES animated:YES];
    [self.finishedTable setEditing:YES animated:YES];
}


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    HayateAppDelegate *appDelegate=APPDELEGETE;
    appDelegate.downloadDelegate=self;
    self.downingList=appDelegate.downinglist;
//    self.finishedList=appDelegate.finishedlist;
    self.finishedList=[[[NSMutableArray alloc] init] autorelease];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getTargetFloderPath] error:&error];
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    for(NSString *fileName in filelist)
    {
        if([fileName rangeOfString:@"."].location<100)//出去Temp文件夹
        {
            FileModel *finishedFile=[[FileModel alloc] init];
            finishedFile.fileName=fileName;
            
            //根据文件名获取文件的大小
            NSInteger length=[[fileManager contentsAtPath:[[CommonHelper getTargetFloderPath] stringByAppendingPathComponent:fileName]] length];
            finishedFile.fileSize=[CommonHelper getFileSizeString:[NSString stringWithFormat:@"%d",length]];
            
            [self.finishedList addObject:finishedFile];
            [finishedFile release];
        }
    }
    [self.downloadingTable reloadData];
    [self.finishedTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.downloadingTable reloadData];
    [self.finishedTable reloadData];
    
//    UIImageView *downingImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background3.jpg"]];
//    downingImg.alpha=0.3f;
//    self.downloadingTable.backgroundView=downingImg;
//    [downingImg release];
//    
//    UIImageView *finishedImg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"finished_bg.jpg"]];
//    finishedImg.alpha=0.3f;
//    self.finishedTable.backgroundView=finishedImg;
//    [finishedImg release];
    
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"已下载的文件" style:UIBarButtonItemStylePlain target:self action:@selector(showFinished)]autorelease];
//    self.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(enterEdit)]autorelease];
    }

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.downloadingTable=nil;
    self.finishedTable=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma 表格数据源

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.downloadingTable)
    {
        return [self.downingList count];
    }
    else
    {
        return [self.finishedList count];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.downloadingTable deselectRowAtIndexPath:indexPath animated:NO];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==self.downloadingTable)//正在下载的文件列表
    {
        static NSString *downCellIdentifier=@"DownloadCell";
        DownloadCell *cell=(DownloadCell *)[self.downloadingTable dequeueReusableCellWithIdentifier:downCellIdentifier];
        if(cell==nil)
        {
            NSArray *objlist=[[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:self options:nil];
            for(id obj in objlist)
            {
                if([obj isKindOfClass:[DownloadCell class]])
                {
                    cell=(DownloadCell *)obj;
                }
            }
        }
        ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:indexPath.row];
        FileModel *fileInfo=[theRequest.userInfo objectForKey:@"File"];
        cell.fileName.text=fileInfo.fileName;
        cell.fileSize.text=fileInfo.fileSize;
        cell.fileInfo=fileInfo;
        cell.request=theRequest;
        cell.fileCurrentSize.text=[CommonHelper getFileSizeString:fileInfo.fileReceivedSize];
//        cell.filebaifen.text=[CommonHelper getFileSizeString:fileInfo.fileReceivedSize]/fileInfo.fileSize
        [cell.progress setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
        if(fileInfo.isDownloading==YES)//文件正在下载
        {
            [cell.operateButton setBackgroundImage:[UIImage imageNamed:@"DownLoad.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.operateButton setBackgroundImage:[UIImage imageNamed:@"Pause3.png"] forState:UIControlStateNormal];
        }
        
        return cell;
    }
    else if(tableView==self.finishedTable)//已完成下载的列表
    {
        static NSString *finishedCellIdentifier=@"FinishedCell";
        FinishedCell *cell=(FinishedCell *)[self.finishedTable dequeueReusableCellWithIdentifier:finishedCellIdentifier];
        if(cell==nil)
        {
            NSArray *objlist=[[NSBundle mainBundle] loadNibNamed:@"FinishedCell" owner:self options:nil];
            for(id obj in objlist)
            {
                if([obj isKindOfClass:[FinishedCell class]])
                {
                    cell=(FinishedCell *)obj;
                }
            }
        }
        FileModel *fileInfo=[self.finishedList objectAtIndex:indexPath.row];
        cell.fileNameLabel.text=fileInfo.fileName;
        cell.fileSizeLabel.text=fileInfo.fileSize;
        cell.fileInfo=fileInfo;
        return cell;
    }
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)//点击了删除按钮,注意删除了该视图列表的信息后，还要更新UI和APPDelegate里的列表
    {
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        if(tableView.tag==101)//正在下载的表格
        {
            ASIHTTPRequest *theRequest=[self.downingList objectAtIndex:indexPath.row];
            if([theRequest isExecuting])
            {
                [theRequest cancel];
            }
            FileModel *fileInfo=(FileModel*)[theRequest.userInfo objectForKey:@"File"];
//            NSString *path=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]];
            NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
            NSString *name=[fileInfo.fileName substringToIndex:index];
            NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]];
//            [fileManager removeItemAtPath:path error:&error];
            [fileManager removeItemAtPath:configPath error:&error];
            if(!error)
            {
                NSLog(@"%@",[error description]);
            }
            [self.downingList removeObjectAtIndex:indexPath.row];
            [self.downloadingTable reloadData];
        }
        else//已经完成下载的表格
        {
//            FileModel *selectFile=[self.finishedList objectAtIndex:indexPath.row];
//            NSString *path=[[CommonHelper getTargetFloderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",selectFile.fileName]];
//            
//            [fileManager removeItemAtPath:path error:&error];
//            if(!error)
//            {
//                NSLog(@"%@",[error description]);
//            }
//            [self.finishedList removeObject:selectFile];
//            [self.finishedTable reloadData];
            
            FileModel *selectFile=[self.finishedList objectAtIndex:indexPath.row];
            
            NSString *removeName=selectFile.fileName;
            [finishedList removeObjectAtIndex:indexPath.row];
            Memo *mymemo=[[Memo alloc] init];
            [mymemo deleteOldFile:removeName];
            NSLog(@"%@",removeName);
            
            [self.finishedTable reloadData];

            
        }
    }
}

-(void)updateCellOnMainThread:(FileModel *)fileInfo
{
    for(id obj in self.downloadingTable.subviews)
    {
        if([obj isKindOfClass:[DownloadCell class]])
        {
            DownloadCell *cell=(DownloadCell *)obj;
            if(cell.fileInfo.fileURL==fileInfo.fileURL)
            {
                cell.fileCurrentSize.text=[CommonHelper getFileSizeString:fileInfo.fileReceivedSize];
                [cell.progress setProgress:[CommonHelper getProgress:[CommonHelper getFileSizeNumber:fileInfo.fileSize] currentSize:[fileInfo.fileReceivedSize floatValue]]];
            }
        }
    }
}

-(void)updateCellProgress:(ASIHTTPRequest *)request;
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}
-(void)finishedDownload:(ASIHTTPRequest *)request;
{
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    [self.downingList removeObject:request];
    [self.finishedList addObject:fileInfo];
    [self.downloadingTable reloadData];
    [self.finishedTable reloadData];
}

@end
