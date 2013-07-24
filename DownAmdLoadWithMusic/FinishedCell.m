//
//  FinishedCell.m
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import "FinishedCell.h"


@implementation FinishedCell

@synthesize fileInfo;
@synthesize fileNameLabel;
@synthesize fileSizeLabel;
@synthesize img;

- (void)dealloc
{
    [fileInfo release];
    [fileSizeLabel release];
    [fileNameLabel release];
    [super dealloc];
}


@end

