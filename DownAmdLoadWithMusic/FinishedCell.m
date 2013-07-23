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
@synthesize fileLabel;
@synthesize img;

- (void)dealloc
{
    [fileInfo release];
    [fileSizeLabel release];
    [fileNameLabel release];
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.img=[[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)]autorelease];
        [self.contentView addSubview:self.img];
        
        self.fileNameLabel=[[[UILabel alloc]initWithFrame:CGRectMake(70, 50,140 , 30)]autorelease];
        [self.contentView addSubview:self.fileNameLabel];
        
        self.fileLabel=[[[UILabel alloc]initWithFrame:CGRectMake(70, 50,70 , 30)]autorelease];
        [self.contentView addSubview:self.fileLabel];
        
        self.fileSizeLabel=[[[UILabel alloc]initWithFrame:CGRectMake(140, 10,70 , 30)]autorelease];
        [self.contentView addSubview:self.fileSizeLabel];
        
    }
    return self;
}

@end

