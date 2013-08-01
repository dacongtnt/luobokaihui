//
//  HsData.m
//  myquick
//
//  Created by 张 伟 on 13-7-25.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "HsData.h"

@interface HsData ()

@end

@implementation HsData

- (NSArray *)filesReturn
{
    NSFileManager *fm=[NSFileManager defaultManager];
    tmpDir = NSTemporaryDirectory();
    arra=[[NSArray alloc]init];
    arra=[fm subpathsAtPath:tmpDir];
    marra=[[NSMutableArray alloc]init];
    for (int i=1; i<[arra count]; i++) {
        [marra addObject:[arra objectAtIndex:i]];
    }
    return marra;
}

@end
