//
//  MDAudioFile.h
//  Audio
//
//  Created by 吕 布 on 13-7-20.
//  Copyright (c) 2013年 吕 布. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface MDAudioFile : NSObject
{
	NSURL			*filePath;
	NSDictionary	*fileInfoDict;
}

@property (nonatomic, retain) NSURL *filePath;
@property (nonatomic, retain) NSDictionary *fileInfoDict;


//获取数据
- (MDAudioFile *)initWithPath:(NSURL *)path;
//id3tags解析
- (NSDictionary *)songID3Tags;

- (NSString *)title;
- (NSString *)artist;
- (NSString *)album;
- (float)duration;
- (NSString *)durationInMinutes;
- (UIImage *)coverImage;

@end
