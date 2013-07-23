//
//  BaiduMusicHelper.h
//  DownLoad3
//
//  Created by 张翼德 on 13-7-20.
//  Copyright (c) 2013年 张飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "FileModel.h"
#import "ASIHTTPRequest.h"

@interface BaiduMusicHelper : NSObject
<NSXMLParserDelegate>
//通过歌曲名字得到可以下载的歌曲信息
+(NSData *)getDataByMusicName:(NSString *)musicName;

@end
