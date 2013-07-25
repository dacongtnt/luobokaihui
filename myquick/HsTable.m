//
//  HsTable.m
//  myquick
//
//  Created by 张 伟 on 13-7-25.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "HsTable.h"
#import "HsData.h"
#import "HsCell.h"

@interface HsTable ()

@end

@implementation HsTable

- (id)init
{
    self=[super init];
    if (self){
        files=[[NSArray alloc]init];
        HsData *cView=[[HsData alloc]init];
        files=[cView filesReturn];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentTime=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    currentTime.font = [UIFont boldSystemFontOfSize:14];
    currentTime.shadowOffset = CGSizeMake(0, -1);
    currentTime.shadowColor = [UIColor blackColor];
    currentTime.backgroundColor = [UIColor clearColor];
    currentTime.textColor = [UIColor whiteColor];
    currentTime.textAlignment = UITextAlignmentRight;
    
    allTime=[[UILabel alloc]initWithFrame:CGRectMake(260, 0, 40, 20)];
    allTime.font = [UIFont boldSystemFontOfSize:14];
    allTime.shadowOffset = CGSizeMake(0, -1);
    allTime.shadowColor = [UIColor blackColor];
    allTime.backgroundColor = [UIColor clearColor];
    allTime.textColor = [UIColor whiteColor];
    allTime.textAlignment = UITextAlignmentRight;
    
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 340, 320, 120)];
    view.backgroundColor=[UIColor blackColor];
    view.alpha=0.7;
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setBackgroundImage:[UIImage imageNamed:@"011.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(120, 40, 100, 40)];
    
    _progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(60, 4, 200, 4)];
    [view addSubview:_progressView];
    [_progressView release];
    [view addSubview:button];
    [view addSubview:currentTime];
    [currentTime release];
    [view addSubview:allTime];
    [allTime release];
    
    tableView0=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 440) style:UITableViewStylePlain];
    tableView0.delegate=self;
    tableView0.dataSource=self;
    tableView0.rowHeight=70;
    tableView0.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableView0];
    self.navigationItem.title=@"语音备忘录";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [files count];
}

- (HsCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=@"cel";
    HsCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[HsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.labelTitle.text=[files lastObject];
    cell.labelTime.text=[NSString stringWithFormat:@"%d:%02d", (int)[avPlayer duration] / 60, (int)[avPlayer duration] % 60, nil];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    recordedTmpFile=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:[files objectAtIndex:indexPath.row]]];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:recordedTmpFile error:&error];
    [avPlayer prepareToPlay];
    [avPlayer play];
    
    //歌曲时间
    NSString *current=[NSString stringWithFormat:@"%d:%02d", (int)[avPlayer duration] / 60, (int)[avPlayer duration] % 60, nil];
    allTime.text=current;
    
    [self.view addSubview:view];
    [view release];
    _progressView.progress=0.0f;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(refreshUR:) userInfo:nil repeats:YES];
}

-(void)refreshUR:(NSTimer *)aTimer{
    
    int i2=(int)((int)(avPlayer.duration - avPlayer.currentTime)) % 60;
    
    if (i2==0) {
        [timer invalidate];
    }else{
        
        //播放时间
        NSString *current = [NSString stringWithFormat:@"%d:%02d", (int)avPlayer.currentTime / 60, (int)avPlayer.currentTime % 60, nil];
        currentTime.text=current;
        float p=avPlayer.currentTime/avPlayer.duration;
        _progressView.progress=p;
    }
}

@end
