//
//  HsCell.m
//  myquick
//
//  Created by 张 伟 on 13-7-25.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "HsCell.h"

@implementation HsCell
@synthesize labelTitle,labelTime,labelDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelTitle=[[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 230, 20)]autorelease];
//        self.labelTitle.backgroundColor=[UIColor clearColor];
        self.labelTitle.textColor=[UIColor blackColor];
        self.labelTitle.font=[UIFont boldSystemFontOfSize:25];
        [self.contentView addSubview:self.labelTitle];
        
        self.labelTime=[[[UILabel alloc]initWithFrame:CGRectMake(260, 10, 60, 20)]autorelease];
//        self.labelTime.backgroundColor=[UIColor clearColor];
        self.labelTime.textColor=[UIColor blackColor];
        self.labelTime.font=[UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.labelTime];
        
        self.labelDate=[[[UILabel alloc]initWithFrame:CGRectMake(10, 40, 200, 10)]autorelease];
//        self.labelDate.backgroundColor=[UIColor clearColor];
        self.labelDate.textColor=[UIColor blackColor];
        self.labelDate.font=[UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:self.labelDate];
    }
    return self;
}

@end
