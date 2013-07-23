//
//  RootViewController.m
//  Audio
//
//  Created by 吕 布 on 13-7-20.
//  Copyright (c) 2013年 吕 布. All rights reserved.
//

#import "AudioView.h"
#import "MDAudioFile.h"
#import "MDAudioPlayerController.h"
#import "Memo.h"

@implementation AudioView

@synthesize fileArray,tableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Memo *mymemo=[[Memo alloc]init];
    
    self.tableView=[[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStylePlain]autorelease];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
	self.fileArray = [[NSMutableArray alloc]initWithArray:[mymemo loadOldFile]];
    
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fileArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell.showsReorderControl=YES;
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.text = [[NSString stringWithFormat:@"%@", [self.fileArray objectAtIndex:indexPath.row]] stringByDeletingPathExtension];
    return cell;
    
}

//cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [fileArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGContextRef *context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"curl" context:context];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    
    [UIView commitAnimations];
    
	NSMutableArray *songs = [[NSMutableArray alloc] init];
	Memo *mymemo=[[Memo alloc]init];
    
    [songs removeAllObjects];
	for (NSString *song in fileArray)
	{
        NSString *soundFilePath=[mymemo.filePath stringByAppendingPathComponent:song];
        //初始化音频类 并且添加播放文件,把音频文件转换成url格式
		MDAudioFile *audioFile = [[MDAudioFile alloc] initWithPath:[NSURL fileURLWithPath:soundFilePath]];
        
		[songs addObject:audioFile];
	}
    //添加控制器
	MDAudioPlayerController *audioPlayer = [[MDAudioPlayerController alloc] initWithSoundFiles:songs atPath:[[NSBundle mainBundle] bundlePath] andSelectedIndex:indexPath.row];
    
	[self.navigationController presentModalViewController:audioPlayer animated:YES];
	[audioPlayer release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}
@end