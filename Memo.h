//
//  Memo.h
//  MemoForPersonal
//
//  Created by 赵云 on 13-7-11.
//  Copyright (c) 2013年 赵云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memo : NSObject
@property(nonatomic,retain) NSString *filePath;
@property(nonatomic,retain) NSFileManager *fileManagerOne;
@property(nonatomic,retain) NSString *color;
-(NSArray*)loadOldFile;
-(void)addNewFile:(NSString*)fileName contents:(NSString*)neirong;
-(void)deleteOldFile:(NSString*)fileName;
@end
