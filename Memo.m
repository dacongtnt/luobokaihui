//
//  Memo.m
//  MemoForPersonal
//
//  Created by 赵云 on 13-7-11.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import "Memo.h"

@implementation Memo
@synthesize filePath,fileManagerOne;

-(id)init
{
    self=[super init];
    if (self) {
        NSString *DocumentDirectorys=[[NSString alloc] initWithString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
        self.filePath=[[NSString alloc] initWithString:[DocumentDirectorys stringByAppendingPathComponent:@"Songs"]];
        self.fileManagerOne=[NSFileManager defaultManager];
        [fileManagerOne createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:nil];
        [DocumentDirectorys release];
        NSLog(@"测试请暂时往路径中放置歌曲%@",filePath);
    }
    
    return self;
}

-(void)dealloc
{
    [filePath release];
    filePath=nil;
    [super dealloc];
}

-(NSArray*)loadOldFile
{
    NSArray *fileArray=[fileManagerOne subpathsOfDirectoryAtPath:filePath error:nil];
    return fileArray;
}
-(void)addNewFile:(NSString*)fileName contents:(NSString*)neirong
{
    [fileManagerOne createFileAtPath:[filePath stringByAppendingPathComponent:fileName] contents:[neirong dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}
-(void)deleteOldFile:(NSString*)fileName
{
    [fileManagerOne removeItemAtPath:[filePath stringByAppendingString:fileName] error:nil];
}
@end
